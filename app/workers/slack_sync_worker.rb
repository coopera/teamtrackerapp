require 'json'

class SlackSyncWorker
  include Sidekiq::Worker
  sidekiq_options unique: :until_executed

  def perform(org, token)
    @token = token

    ActiveRecord::Base.transaction do
      app_data = AppData.find_by(organization: org)
      @last_updated = app_data.last_updated
      older_last_updated = DateTime.current - 10.years

      puts "https://slack.com/api/users.list?#{build_channels_query}"
      members = Hash[
        JSON.parse(RestClient.get("https://slack.com/api/users.list?#{build_channels_query}"))["members"].map do |message|
          ["<@#{message["id"]}>", message["name"]]
        end
      ]

      @oldest = '1000000000.000000'

      puts "https://slack.com/api/channels.list?#{build_channels_query}"
      channels = Hash[
        JSON.parse(RestClient.get("https://slack.com/api/channels.list?#{build_channels_query}"))["channels"].map do |channel|
          [channel["id"], channel["name"]]
        end
      ]

      channels.each do |channel|
        @channel = channel["id"]
        has_more = true
        @last_updated = app_data.last_updated

        while has_more
          puts "https://slack.com/api/channels.history?#{build_history_query}"
          history = JSON.parse(RestClient.get("https://slack.com/api/channels.history?#{build_history_query}"))

          history["messages"].each do |message|
            @last_updated = Time.at(message["ts"].to_f)
            @oldest = message["ts"]

            next if message["type"] != "message" || message["text"].blank?

            SlackMessage.create do |sm|
              sm.text = message["text"].gsub(/<(@\S+)>/) { |s| "<#{members[s] || s}>" }
              sm.author = members["<@#{message["user"]}>"]
              sm.channel = channels[@channel]
              sm.organization = org
              sm.date = Time.at(message["ts"].to_f)
            end
          end

          has_more = history["has_more"]
        end

        if @last_updated > older_last_updated
          older_last_updated = app_data.last_updated
        end
      end

      app_data.last_updated = older_last_updated
      app_data.save
    end
  end

  def build_channels_query
    { token: @token }.to_query
  end

  def build_history_query
    { token: @token, channel: @channel, oldest: @oldest }.to_query
  end
end

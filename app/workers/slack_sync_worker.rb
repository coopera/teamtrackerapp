require 'json'

class SlackSyncWorker
  include Sidekiq::Worker
  sidekiq_options unique: :until_executed

  def perform(org, token)
    @token = token

    return true
    ActiveRecord::Base.transaction do
      app_data = AppData.find_by(organization: org)
      @last_updated = app_data.last_updated.to_f

      puts "https://slack.com/api/channels.list?#{build_channels_query}"
      channels = JSON.parse(RestClient.get("https://slack.com/api/channels.list?#{build_channels_query}"))["channels"]

      channels.each do |channel|
        @channel = channel["id"]
        has_more = true

        while has_more
          puts "https://slack.com/api/channels.history?#{build_history_query}"
          history = JSON.parse(RestClient.get("https://slack.com/api/channels.history?#{build_history_query}"))

          history["messages"].each do |message|
            @last_updated = message["ts"]

            next if message["type"] != "message"

            SlackMessage.create do |sm|
              sm.text = message["text"]
              sm.author = message["author"]
              sm.channel = @channel
              sm.organization = org
              sm.date = Time.at(message["ts"].to_f)
            end
          end

          if !history["has_more"]
            has_more = false
          end
        end

      end

      app_data.last_updated = @last_updated
      app_data.save
    end
  end

  def build_channels_query
    { token: @token }.to_query
  end

  def build_history_query
    { token: @token, channel: @channel, oldest: @last_updated }.to_query
  end
end

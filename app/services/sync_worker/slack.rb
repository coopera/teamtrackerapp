require 'json'

class SyncWorker::Slack < SyncWorker::Base

  def process(org, token)
    @token = token
    return if token.blank?

    file = File.open('foo.log', File::WRONLY | File::APPEND)
    # To create new (and to remove old) logfile, add File::CREAT like:
    # file = File.open('foo.log', File::WRONLY | File::APPEND | File::CREAT)
    logger = Logger.new(file)

    ActiveRecord::Base.transaction do
      app_data = AppData.find_by(organization: org)
      @oldest = app_data.last_slack_ts || '1000000000.000000'
      last_oldest = @oldest

      puts "https://slack.com/api/users.list?#{build_channels_query}"
      members = Hash[
        JSON.parse(RestClient.get("https://slack.com/api/users.list?#{build_channels_query}"))["members"].map do |message|
          ["<@#{message["id"]}>", message["name"]]
        end
      ]

      puts "https://slack.com/api/channels.list?#{build_channels_query}"
      channels = Hash[
        JSON.parse(RestClient.get("https://slack.com/api/channels.list?#{build_channels_query}"))["channels"].map do |channel|
          [channel["id"], channel["name"]]
        end
      ]

      logger.info(members)
      logger.info(channels)

      channels.keys.each do |channel|
        @channel = channel
        has_more = true

        while has_more
          puts "https://slack.com/api/channels.history?#{build_history_query}"
          history = JSON.parse(RestClient.get("https://slack.com/api/channels.history?#{build_history_query}"))

          history["messages"].each do |message|
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

        if @oldest.to_f > last_oldest.to_f
          last_oldest = @oldest
        end
      end

      app_data.last_slack_ts = last_oldest
      app_data.slack_token = token
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

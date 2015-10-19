class SlackSyncWorker
  include Sidekiq::Worker
  sidekiq_options unique: :while_executing

  def perform(org, token)
    SyncWorker::Slack.new.process(org, token)
  end
end

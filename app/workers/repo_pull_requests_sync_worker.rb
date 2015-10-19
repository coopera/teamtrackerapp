class RepoPullRequestsSyncWorker
  include Sidekiq::Worker
  sidekiq_options unique: :until_executed

  def perform(org, repo)
    SyncWorker::RepoPullRequests.process(org, repo)
  end
end

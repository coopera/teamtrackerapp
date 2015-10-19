class PullRequestCommitsSyncWorker
  include Sidekiq::Worker
  sidekiq_options unique: :until_executed

  def perform(org, repo, number)
    SyncWorker::PullRequestCommits.process(org, repo, number)
  end
end

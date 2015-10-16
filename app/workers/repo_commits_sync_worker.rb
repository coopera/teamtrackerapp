class RepoCommitsSyncWorker
  include Sidekiq::Worker
  sidekiq_options unique: :until_executed

  def perform(org, repo)
    SyncWorker::RepoCommits.process(org, repo)
  end
end

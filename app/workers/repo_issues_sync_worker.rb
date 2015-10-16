class RepoIssuesSyncWorker
  include Sidekiq::Worker
  sidekiq_options unique: :until_executed

  def perform(org, repo)
    SyncWorker::RepoIssues.process(org, repo)
  end
end

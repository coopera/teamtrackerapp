class CommentsSyncWorker
  include Sidekiq::Worker
  sidekiq_options unique: :until_executed

  def perform(org, repo, number, type)
    SyncWorker::Comments.process(org, repo, number, type)
  end
end

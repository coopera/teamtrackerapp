class OrgRepositoriesSyncWorker
  include Sidekiq::Worker
  sidekiq_options unique: :until_executed

  def perform(org)
    SyncWorker::OrgRepositories.process(org)
  end
end

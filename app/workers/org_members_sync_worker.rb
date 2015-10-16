class OrgMembersSyncWorker
  include Sidekiq::Worker
  sidekiq_options unique: :until_executed

  def perform(org)
    SyncWorker::OrgMembers.process(org)
  end
end

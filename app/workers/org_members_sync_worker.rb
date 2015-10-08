class OrgMembersSyncWorker < SyncWorker
  include Sidekiq::Worker

  def perform(org)
    ActiveRecord::Base.transaction do
      Member.where(organization: org).destroy_all

      octokit.organization_members(org).each do |member|
        Member.create(name: member.login, avatar_url: member.avatar_url,
          organization: org)
      end
    end
  end
end

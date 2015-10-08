class OrgRepositoriesSyncWorker < SyncWorker
  include Sidekiq::Worker

  def perform(org)
    ActiveRecord::Base.transaction do
      Repository.where(organization: org).destroy_all

      octokit.organization_repositories(org).each do |repo|
        repository = Repository.create(name: repo.name, organization: org)

        RepoIssuesSyncWorker.perform_async(org, repo.name)
        RepoCommitsSyncWorker.perform_async(org, repo.name)
        RepoPullRequestsSyncWorker.perform_async(org, repo.name)
      end
    end
  end
end

class SyncWorker::OrgRepositories < SyncWorker::Base
  def self.process(org)
    ActiveRecord::Base.transaction do
      Repository.where(organization: org).destroy_all

      octokit.organization_repositories(org).each do |repo|
        Repository.create(name: repo.name, organization: org)

        RepoIssuesSyncWorker.perform_async(org, repo.name)
        RepoCommitsSyncWorker.perform_async(org, repo.name)
        RepoPullRequestsSyncWorker.perform_async(org, repo.name)
      end
    end
  end
end

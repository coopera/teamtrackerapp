class RepoCommitsSyncWorker < SyncWorker
  include Sidekiq::Worker
  sidekiq_options unique: :until_executed

  def perform(org, repo)
    ActiveRecord::Base.transaction do
      Commit.where(organization: org, repo: repo, pr_number: nil).destroy_all

      octokit.commits("#{org}/#{repo}").each do |commit|
        Commit.create(sha: commit.sha, author: commit.author.login, message: commit.commit.message,
          organization: org, repo: repo, date: commit.author.date)
      end rescue nil
    end
  end
end

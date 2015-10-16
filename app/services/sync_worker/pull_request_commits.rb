class SyncWorker::PullRequestCommits < SyncWorker::Base
  def self.process(org, repo, number)
    Commit.where(organization: org, repo: repo, pr_number: number).destroy_all

    octokit.pull_request_commits("#{org}/#{repo}", number).each do |commit|
      Commit.create(sha: commit.sha, author: commit.author.login, message: commit.commit.message,
        organization: org, repo: repo, date: commit.author.date, pr_number: number)
    end
  end
end

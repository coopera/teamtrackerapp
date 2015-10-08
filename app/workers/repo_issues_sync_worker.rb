class RepoIssuesSyncWorker < SyncWorker
  include Sidekiq::Worker

  def perform(org, repo)
    ActiveRecord::Base.transaction do
      Issue.where(organization: org, repo: repo).destroy_all

      octokit.issues("#{org}/#{repo}", state: 'all').each do |iss|
        next if iss.pull_request

        issue = Issue.new(number: iss.number, repo: repo, organization: org)
        issue.state = iss.state
        issue.closed_at = iss.closed_at
        issue.date = iss.created_at
        issue.title = iss.title
        issue.body = iss.body
        issue.author = iss.user.login
        issue.save

        CommentsSyncWorker.new.perform(org, repo, iss.number, :issue)
      end

    end
  end
end

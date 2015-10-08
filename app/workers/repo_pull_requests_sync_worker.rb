class RepoPullRequestsSyncWorker < SyncWorker
  include Sidekiq::Worker

  def perform(org, repo)
    PullRequest.where(organization: org, repo: repo).destroy_all

    octokit.pull_requests("#{org}/#{repo}", state: 'all').each do |pr|
      pull = PullRequest.new(number: pr.number, repo: repo, organization: org)
      pull.state = pr.state
      pull.merged_at = pr.merged_at
      pull.date = pr.created_at
      pull.body = pr.body
      pull.title = pr.title
      pull.author = pr.user.login
      pull.save

      PullRequestCommitsSyncWorker.new.perform(org, repo, pr.number)
      CommentsSyncWorker.new.perform(org, repo, pr.number, :pull_request)
    end
  end
end

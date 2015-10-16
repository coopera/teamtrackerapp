class SyncWorker::RepoPullRequests < SyncWorker::Base
  def self.process(org, repo)
    PullRequest.where(organization: org, repo: repo).destroy_all

    octokit.pull_requests("#{org}/#{repo}", state: 'all').each do |pr|
      PullRequest.create(
        number: pr.number,
        repo: repo,
        organization: org,
        state: pr.state,
        merged_at: pr.merged_at,
        date: pr.created_at,
        body: prd.body,
        title: pr.title,
        author: pr.user.login)

      PullRequestCommitsSyncWorker.new.perform(org, repo, pr.number)
      CommentsSyncWorker.new.perform(org, repo, pr.number, :pull_request)
    end
  end
end

class SyncWorker::RepoIssues < SyncWorker::Base
  def self.process(org, repo)
    ActiveRecord::Base.transaction do
      Issue.where(organization: org, repo: repo).destroy_all

      octokit.issues("#{org}/#{repo}", state: 'all').each do |iss|
        next if iss.pull_request

        Issue.create(
          number: iss.number,
          repo: repo,
          organization: org
          state: iss.stae,
          closed_at: iss.closed_at,
          date: iss.created_at,
          title: iss.title,
          body: iss.body,
          author: iss.user.login)

        CommentsSyncWorker.new.perform(org, repo, iss.number, :issue)
      end
    end
  end
end

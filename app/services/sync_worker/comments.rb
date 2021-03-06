class SyncWorker::Comments < SyncWorker::Base
  def self.process(org, repo, number, type)
    ActiveRecord::Base.transaction do
      Comment.where(organization: org, repo: repo, number: number).destroy_all

      octokit.send("#{type}_comments", "#{org}/#{repo}", number).each do |comment|
        Comment.create(date: comment.created_at, author: comment.user.login, repo: repo,
          organization: org, body: comment.body, number: number)
      end
    end
  end
end

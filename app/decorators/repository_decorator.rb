class RepositoryDecorator < Draper::Decorator
  delegate_all

  def number_of_commits
    Commit.where(where).count
  end

  def number_of_comments
    Comment.where(where).count
  end

  def number_of_slack_messages
    SlackMessage.where(where).count
  end

  def number_of_issues_open
    Issue.where(where.merge(state: 'open')).count
  end

  def number_of_issues_closed
    Issue.where(where.merge(state: 'closed')).count
  end

  private

  def where
    { organization: object.organization, repo: object.name }
  end
end

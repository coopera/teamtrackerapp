class MemberDecorator < Draper::Decorator
  delegate_all

  def number_of_commits
    Commit.where(author: object.name, organization: object.organization).count
  end

  def number_of_comments
    Comment.where(author: object.name, organization: object.organization).count
  end

  def number_of_slack_messages
    return 0 if slack == "not set"
    SlackMessage.where(author: slack, organization: object.organization).count
  end

  def slack
    @slack ||= SlackGithub.find_by(github: object.name, organization: object.organization).try(:slack) || "not set"
  end
end

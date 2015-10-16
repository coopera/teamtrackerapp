class OrganizationDecorator < Draper::Decorator
  delegate_all

  def number_of_commits
    Commit.where(organization: object).count
  end

  def number_of_comments
    Comment.where(organization: object).count
  end

  def number_of_slack_messages
    SlackMessage.where(organization: object).count
  end

  def number_of_issues_open
    Issue.where(organization: object, state: 'open').count
  end

  def number_of_issues_closed
    Issue.where(organization: object, state: 'closed').count
  end

  def gh_last_sync
    return 'never' unless AppData.find_by(organization: object).gh_last_updated
    AppData.find_by(organization: object).gh_last_updated.to_formatted_s(:long)
  end

  def slack_last_sync
    return 'never' unless AppData.find_by(organization: object).slack_last_updated
    AppData.find_by(organization: object).slack_last_updated.to_formatted_s(:long)
  end

  def slack_token
    AppData.find_by(organization: object).slack_token
  end
end

class Admin::DashboardController < ApplicationController
  def dashboard
    @members = MemberDecorator.decorate_collection(
      Member.where(organization: params[:organization])
    )
    @repos = RepositoryDecorator.decorate_collection(
      Repository.where(organization: params[:organization])
    ).sort_by(&:number_of_commits).reverse!
    @organization = OrganizationDecorator.decorate(
      params[:organization]
    )
    @slack_members = SlackMessage.pluck(:author).uniq
  end

  def member
    @commits = Commit.where(organization: params[:organization], author: params[:member]).order('date DESC')
    @pull_requests = PullRequest.where(organization: params[:organization], author: params[:member]).order('date DESC')
    @issues = Issue.where(organization: params[:organization], author: params[:member]).order('date DESC')
    @comments = Comment.where(organization: params[:organization]).order('date DESC')
  end

  def sync_github
    GithubSyncService.perform(params([:organization]))
  end

  def sync_slack
    SlackSyncService.perform(params[:organization], params[:token])
  end

  def slack_github
    sg = SlackGithub.find_or_initialize_by(organization: params[:organization], github: params[:github])
    sg.slack = params[:slack]
    sg.save

    render nothing: true
  end

  def needs_sync?
    return false
  end

end

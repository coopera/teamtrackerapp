class Admin::DashboardController < Admin::AdminController
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
    @non_pr_commits = CommitDecorator.decorate_collection(
      Commit.where(organization: params[:organization], author: params[:member], pr_number: nil)
      .order('date DESC')
    ).group_by(&:repo)
    @opened_prs = PullRequestDecorator.decorate_collection(
      PullRequest.where(organization: params[:organization], author: params[:member])
      .order('date DESC')
    ).group_by(&:repo)
    @opened_issues = IssueDecorator.decorate_collection(
      Issue.where(organization: params[:organization], author: params[:member])
      .order('date DESC')
    ).group_by(&:repo)
    @comments = Comment.where(organization: params[:organization])
      .order('date DESC').group_by(&:repo)
  end

  def sync_github
    GithubSyncService.perform(params[:organization])

    app_data.gh_last_updated = DateTime.current
    app_data.save

    redirect_to admin_organization_path
  end

  def sync_slack
    SlackSyncService.perform(params[:organization], params[:token])

    app_data.slack_last_updated = DateTime.current
    app_data.save

    redirect_to admin_organization_path
  end

  def slack_github
    sg = SlackGithub.find_or_initialize_by(organization: params[:organization], github: params[:github])
    sg.slack = params[:slack]
    sg.save

    render nothing: true
  end

end

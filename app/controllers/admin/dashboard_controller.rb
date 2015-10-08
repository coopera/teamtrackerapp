class Admin::DashboardController < ApplicationController
  def dashboard
    @members = Member.where(organization: params[:organization])
  end

  def member
    @commits = Commit.where(organization: params[:organization], author: params[:member]).order('date DESC')
    @pull_requests = PullRequest.where(organization: params[:organization], author: params[:member]).order('date DESC')
    @issues = Issue.where(organization: params[:organization], author: params[:member]).order('date DESC')
    @comments = Comment.where(organization: params[:organization]).order('date DESC')
  end

  def sync
    SyncService.new(params[:organization]).sync
  end

  def needs_sync?
    return false
  end

end

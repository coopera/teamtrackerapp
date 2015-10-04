class Admin::DashboardController < ApplicationController
  before_filter :sync

  def dashboard
    @members = Member.where(organization: params[:organization])
  end

  def member
    @commits = Commit.where(organization: params[:organization], author: params[:member]).order('date DESC')
    @pull_requests = PullRequest.where(organization: params[:organization], author: params[:member]).order('date DESC')
    @issues = Issue.where(organization: params[:organization], author: params[:member]).order('date DESC')
    @comments = Comment.where(organization: params[:organization]).order('date DESC')
  end

  def repo
  end

  private

  def octokit
    Octokit.auto_paginate = true
    @client ||= Octokit::Client.new(:login => ENV['login'], :password => ENV['password'])
  end

  def sync
    return unless needs_sync?

    octokit.organization_members(params[:organization]).each do |member|
      Member.find_or_create_by(name: member.login, avatar_url: member.avatar_url,
        organization: params[:organization])
    end

    octokit.organization_repositories(params[:organization]).each do |repo|
      repository = Repository.find_or_initialize_by(name: repo.name, organization: params[:organization])

      octokit.commits_since(repository.full_name, app_data.last_updated.to_s).each do |commit|
        Commit.find_or_create_by(sha: commit.sha, author: commit.author.login, message: commit.commit.message,
          organization: params[:organization], repository: repository.name, date: commit.author.date)
      end rescue nil

      octokit.pull_requests(repository.full_name, state: 'all').each do |pr|
        pull = PullRequest.find_or_initialize_by(number: pr.number, repo: repository.name,
          organization: params[:organization])
        pull.state = pr.state
        pull.merged_at = pr.merged_at
        pull.date = pr.created_at
        pull.body = pr.body
        pull.title = pr.title
        pull.author = pr.user.login
        pull.save

        octokit.pull_request_comments(repository.full_name, pr.number).each do |comment|
          Comment.find_or_create_by(date: comment.created_at, author: comment.user.login, repo: repository.name,
            organization: params[:organization], body: comment.body, number: pr.number)
        end
      end

      octokit.issues(repository.full_name, state: 'all').each do |iss|
        issue = Issue.find_or_initialize_by(number: iss.number, repo: repository.name,
          organization: params[:organization])
        issue.state = iss.state
        issue.closed_at = iss.closed_at
        issue.date = iss.created_at
        issue.title = iss.title
        issue.body = iss.body
        issue.author = iss.user.login
        issue.save

        octokit.issue_comments(repository.full_name, iss.number).each do |comment|
          Comment.find_or_create_by(date: comment.created_at, author: comment.user.login, repo: repository.name,
            organization: params[:organization], body: comment.body, number: iss.number)
        end
      end
    end

    app_data.last_updated = DateTime.now
    app_data.save
  end

  def needs_sync?
    last_updated = app_data.last_updated
    return (Time.now - last_updated) > 10.minutes
  end

  def app_data
    @app_data ||= (AppData.first || AppData.create(last_updated: DateTime.new(2001,2,3)))
  end
end

class Admin::DashboardController < ApplicationController
  before_filter :sync

  def dashboard
    @members = Member.where(organization: params[:organization])
  end

  def member
    @commits = Commit.where(organization: params[:organization], author: params[:member]).order(:date)
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
      record = Repository.find_or_initialize_by(name: repo.name, organization: params[:organization])

      octokit.commits_since(record.full_name, app_data.last_updated.to_s).each do |commit|
        Commit.find_or_create_by(sha: commit.sha, author: commit.author.login, message: commit.commit.message,
          organization: params[:organization], repository: record.name, date: commit.author.date)
      end rescue next
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

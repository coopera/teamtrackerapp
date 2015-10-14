class Admin::AdminController < ApplicationController
  before_filter :app_data

  def octokit
    @client ||= Octokit::Client.new(:login => ENV['login'], :password => ENV['password'])
  end

  def app_data
    @app_data ||= (AppData.first || AppData.create(organization: params[:organization]))
  end
end

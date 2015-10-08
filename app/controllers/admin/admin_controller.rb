class AdminController < ApplicationController
  def octokit
    @client ||= Octokit::Client.new(:login => ENV['login'], :password => ENV['password'])
  end

  def app_data
    @app_data ||= (AppData.first || AppData.create(last_updated: DateTime.new(2001,2,3)))
  end
end

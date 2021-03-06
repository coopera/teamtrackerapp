class GithubSyncService < ApplicationService
  def initialize(org)
    @org = org
  end

  def perform
    OrgMembersSyncWorker.perform_async(@org)
    OrgRepositoriesSyncWorker.perform_async(@org)
  end

  private

  def octokit
    @client ||= Octokit::Client.new(:login => ENV['login'], :password => ENV['password'])
  end
end

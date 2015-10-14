class GithubSyncService < ApplicationService
  def initialize(org)
    @org = org
  end

  def perform
    OrgMembersSyncWorker.perform_async(@org)
    OrgRepositoriesSyncWorker.perform_async(@org)

    app_data = AppData.find_by(organization: @org)
    app_data.gh_last_sync = DateTime.current
    app_data.save
  end

  private

  def octokit
    @client ||= Octokit::Client.new(:login => ENV['login'], :password => ENV['password'])
  end
end

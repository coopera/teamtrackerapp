class SyncService
  def initialize(org)
    @org = org
  end

  def sync_github
    OrgMembersSyncWorker.perform_async(@org)
    OrgRepositoriesSyncWorker.perform_async(@org)
  end

  def sync_slack(token)
    SlackSyncWorker.perform_async(@org, token)
  end

  private

  def octokit
    @client ||= Octokit::Client.new(:login => ENV['login'], :password => ENV['password'])
  end
end

class SyncerService < ApplicationService
  def perform
    AppData.select(:organization).pluck(:organization).each do |org|
      GithubSyncService.perform(org)
    end
  end
end

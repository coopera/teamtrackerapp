class SlackSyncService < ApplicationService
  def initialize(org, token)
    @org, @token = org, token
  end

  def perform
    SlackSyncWorker.perform_async(@org, @token)
  end
end

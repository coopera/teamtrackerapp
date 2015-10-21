namespace :import do
  desc 'Load data from Github'
  task 'github' => :environment do
    SyncerService.perform
  end
end

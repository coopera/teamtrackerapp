class SyncWorker
  def octokit
    Octokit.auto_paginate = true
    @client ||= Octokit::Client.new(:login => ENV['login'], :password => ENV['password'])
  end
end

class CommitDecorator < Draper::Decorator
  delegate_all

  def url
    "https://github.com/#{organization}/#{repo}/commit/#{sha}"
  end

  def sha
    object.sha[0..6]
  end
end

class CommentDecorator < Draper::Decorator
  delegate_all

  def activity_url
    "https://github.com/#{organization}/#{repo}/issues/#{number}"
  end
end

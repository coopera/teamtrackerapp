class PullRequestDecorator < Draper::Decorator
  delegate_all

  def merged_badge
    return '<span class="merged badge">Merged</span>'.html_safe if merged_at
    return '<span class="closed badge">Closed</span>'.html_safe if closed_at
    return '<span class="open badge">Open</span>'.html_safe
  end

  def css_class
    return 'merged_at' if merged_at
    return 'closed' if closed_at
    'open'
  end

  def url
    "https://github.com/#{organization}/#{repo}/issues/#{number}"
  end

  def body
    "<p>#{object.body}</p>".html_safe unless object.body.blank?
  end
end

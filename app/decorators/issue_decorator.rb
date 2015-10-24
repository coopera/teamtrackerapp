class IssueDecorator < Draper::Decorator
  delegate_all

  def closed_badge
    return '<span class="closed badge">Closed</span>'.html_safe if closed_at
    return '<span class="open badge">Open</span>'.html_safe
  end

  def css_class
    return 'closed' if closed_at
    'open'
  end

  def url
    "https://github.com/#{organization}/#{repo}/issues/#{number}"
  end
end

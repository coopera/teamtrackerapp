class GrouperService < ApplicationService
  def perform
    {
      pull_request: activities_grouper(group_activity_by_author(PullRequest)),
      commit: activities_grouper(group_activity_by_author(Commit))
    }
  end

  private

  def activities_grouper(activities_by_author)
    hsh = {}
    activities_by_author.each do |author, activities|
      hsh[author] = group_activity_by_date(activities)
    end

    hsh
  end

  def group_activity_by_author(model_class)
    model_class.all.group_by(&:author)
  end

  def group_activity_by_date(activities)
    activities.group_by {|activity| activity.date.try(:to_date) }
  end
end

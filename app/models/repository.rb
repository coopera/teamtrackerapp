class Repository < ActiveRecord::Base
  def full_name
    "#{organization}/#{name}"
  end
end

module UserWithGoalDecorator
  delegate :description, to: :goal, prefix: true
  delegate :target, :target_delta, :daily_goal, :to_go, :projected_value, :projected_date, to: :goal

  def goal
    model.goal.decorate
  end
end

module UserWithoutGoalDecorator
  def goal
    Goal.new.decorate
  end

  def goal_description
    'No goal set'
  end

  def target
    return '?' 
  end

  def target_delta
    return '?' 
  end

  def daily_goal
    return '?' 
  end

  def to_go
    return '?' 
  end

  def projected_value
    return '?' 
  end

  def projected_date
    return '?' 
  end
end

class UserDecorator < ApplicationDecorator
  def initialize(object, options = {})
    super(object, options)
    if object.goal
      (class << self; include UserWithGoalDecorator; end)
    else
      (class << self; include UserWithoutGoalDecorator; end)
    end
  end

  def new_measurement
    Measurement.new(date: Date.today)
  end
end


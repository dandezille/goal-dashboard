module UserWithGoalDecorator
  def goal
    model.goal.decorate
  end

  def goal_description
    goal.description
  end

  def target
    goal.target
  end

  def target_delta
    goal.target_delta
    end

  def daily_goal
    goal.daily_goal
  end

  def to_go
    goal.to_go
  end

  def projected_value
    goal.projected_value
  end

  def projected_date
    goal.projected_date
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


class UserDecorator < ApplicationDecorator
  delegate :current, :chart_definition, to: :goal

  def new_measurement
    Measurement.new(date: Date.today)
  end

  def goal
    (model.goal || Goal.new).decorate
  end

  def goal_description
    return 'No goal set' unless model.goal
    goal.description
  end

  def target
    return '?' unless model.goal
    goal.target
  end

  def target_delta
    return '?' unless model.goal
    goal.target_delta
    end

  def daily_goal
    return '?' unless model.goal
    goal.daily_goal
  end

  def to_go
    return '?' unless model.goal
    goal.to_go
  end

  def projected_value
    return '?' unless model.goal
    goal.projected_value
  end

  def projected_date
    return '?' unless model.goal
    goal.projected_date
  end
end


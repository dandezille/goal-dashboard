class UserStatsDecorator < Draper::Decorator
  delegate_all

  def goal
    if model.goal
      "#{model.goal.value} by #{model.goal.date}"
    else
      'No goal set'
    end
  end

  def pace
    79.1
  end

  def daily_goal
    0.17
  end

  def current
    latest_measurement&.value || '?'
  end

  def to_go
    if latest_measurement and model.goal
      latest_measurement.value - model.goal.value
    else
      '?'
    end
  end

  def projected_value
    77.5
  end

  def projected_date
    '30/04/20'
  end
end


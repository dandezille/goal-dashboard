class UserStatsDecorator < Draper::Decorator
  delegate_all

  def goal
    if model.goal
      "#{model.goal.value} by #{model.goal.end_date}"
    else
      'No goal set'
    end
  end

  def pace
    79.1
  end

  def daily_goal
    if latest_measurement and model.goal
      days_between = (model.goal.end_date - latest_measurement.date).to_i
      per_day = to_go / days_between
      "#{'%.2f' % per_day}"
    else
      '?'
    end
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


class UserStatsDecorator < Draper::Decorator
  delegate_all

  def goal
    if model.goal
      "#{model.goal.end_value} by #{model.goal.end_date}"
    else
      'No goal set'
    end
  end

  def pace
    if model.goal
      days_between = (model.goal.end_date - model.goal.start_date).to_i
      weight_difference = model.goal.end_value - model.goal.start_value
      per_day = weight_difference / days_between
      pace = model.goal.start_value + per_day * (Date.today - model.goal.start_date)
      "#{'%.1f' % pace}"
    else
      '?'
    end
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
      latest_measurement.value - model.goal.end_value
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


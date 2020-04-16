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
    if latest_measurement and model.goal
      predict_value
    else
      '?'
    end
  end

  def projected_date
    if latest_measurement and model.goal
      predict_date
    else
      '?'
    end
  end

  private

  def predict_value
    days_since = measurements.map do |m|
      [(m.date - Date.today).to_i]
    end
    values = measurements.map { |m| m.value }

    linear_regression = RubyLinearRegression.new
    linear_regression.load_training_data(days_since, values)
    linear_regression.train_normal_equation

    value_at_goal_date = linear_regression.predict([model.goal.end_date - Date.today])
    if value_at_goal_date < model.goal.end_value
      model.goal.end_value
    else
      value_at_goal_date
    end
  end

  def predict_date
    days_since = measurements.map do |m|
      (m.date - Date.today).to_i
    end
    values = measurements.map { |m| [m.value] }

    linear_regression = RubyLinearRegression.new
    linear_regression.load_training_data(values, days_since)
    linear_regression.train_normal_equation

    date_at_goal_value = Date.today + linear_regression.predict([model.goal.end_value]).to_i.days
    if date_at_goal_value < model.goal.end_date
      date_at_goal_value
    else
      model.goal.end_date
    end
  end

end


class UserStatsDecorator < Draper::Decorator
  delegate_all

  def new_measurement
    Measurement.new(date: Date.today)
  end

  def new_goal
    Goal.new
  end

  def goal
    if model.goal
      "#{model.goal.end_value}kg by #{h.format_date(model.goal.end_date)}"
    else
      'No goal set'
    end
  end

  def target
    if model.goal
      "#{'%.1f' % target_for_today}"
    else
      '?'
    end
  end

  def target_delta
    if model.goal and model.latest_measurement
      delta = target_for_today - model.latest_measurement.value

      if delta.abs < 0.1
        'on target'
      else
        postscript = delta > 0 ? 'ahead' : 'behind'
        "#{'%.1f' % delta.abs} #{postscript}"
      end
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
    if measurements.count > 1 and model.goal
      prediction = predict_end_value
      prediction = model.goal.end_value if prediction < model.goal.end_value
       "#{'%.1f' % prediction}"
    else
      '?'
    end
  end

  def projected_date
    if measurements.count > 1 and model.goal
      prediction = predict_end_date
      prediction = model.goal.end_date if prediction > model.goal.end_date
      prediction 
    else
      '?'
    end
  end

  def chart_definition
    measurements_data = measurements.map do |m|
      { x: m.date, y: m.value }
    end

    target_data = []
    if model.goal
      target_data = [
        { x: model.goal.start_date, y: model.goal.start_value},
        { x: model.goal.end_date, y: model.goal.end_value}
      ]
    end

    {
      type: 'scatter',
      data: {
        datasets: [
          {
            label: 'Weights',
            showLine: true,
            fill: false,
            backgroundColor: '#444190',
            borderColor: '#444190',
            data: measurements_data
          },
          {
            label: 'Target',
            showLine: true,
            fill: false,
            data: target_data
          } 
        ]
      },
      options: {
        legend: {
          display: false
        },
        scales: {
          xAxes: [{
            type: 'time',
            time: {
              unit: 'day'
            }
          }]
        }
      }
    }.to_json
  end

  private

  def target_for_today
    days_between = (model.goal.end_date - model.goal.start_date).to_i
    weight_difference = model.goal.end_value - model.goal.start_value
    per_day = weight_difference / days_between
    model.goal.start_value + per_day * (Date.today - model.goal.start_date)
  end

  def predict_end_value
    days_since = measurements.map(&method(:days_since_today))
    values = measurements.map(&:value)
    predict(days_since, values, model.goal.end_date - Date.today)
  end

  def predict_end_date
    days_since = measurements.map(&method(:days_since_today))
    values = measurements.map(&:value)
    Date.today + predict(values, days_since, model.goal.end_value).to_i.days
  end

  def days_since_today(measurement)
    (measurement.date - Date.today).to_i
  end

  def predict(x_data, y_data, prediction_value)
    x_data = x_data.map { |x| [x] }

    linear_regression = RubyLinearRegression.new
    linear_regression.load_training_data(x_data, y_data)
    linear_regression.train_normal_equation

    value_at_goal_date = linear_regression.predict([prediction_value])
  end

end


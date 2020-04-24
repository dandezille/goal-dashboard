class UserStatsDecorator < Draper::Decorator
  delegate_all

  def new_measurement
    Measurement.new(date: Date.today)
  end

  def new_goal
    model.goal || Goal.new
  end

  def goal
    if model.goal
      "#{model.goal.end_value}kg by #{h.format_date(model.goal.end_date)}"
    else
      'No goal set'
    end
  end

  def target
    if model.goal and model.latest_measurement
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
      prediction = predict_value_at(model.goal.end_date)
       "#{'%.1f' % prediction}kg at #{h.format_date(model.goal.end_date)}"
    else
      '?'
    end
  end

  def projected_date
    if measurements.count > 1 and model.goal
      predicted  = predict_date_for(model.goal.end_value)
      "#{model.goal.end_value}kg at #{h.format_date(predicted)}"
    else
      '?'
    end
  end

  def chart_definition
    measurements_data = measurements.map do |m|
      { x: m.date, y: m.value }
    end

    target_data = []
    if model.goal and model.first_measurement
      target_data = [
        { x: model.first_measurement.date, y: model.first_measurement.value},
        { x: model.goal.end_date, y: model.goal.end_value}
      ]
    end

    prediction_data = []
    if model.goal and model.measurements.count > 1
      prediction_data = [
        { x: model.first_measurement.date, y: predict_value_at(model.first_measurement.date) },
        { x: model.goal.end_date, y: predict_value_at(model.goal.end_date) },
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
          },
          {
            label: 'Prediction',
            showLine: true,
            fill: false,
            backgroundColor: '#a3bffa',
            borderColor: '#a3bffa',
            data: prediction_data,
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
    days_between = (model.goal.end_date - model.first_measurement.date).to_i
    weight_difference = model.goal.end_value - model.first_measurement.value
    per_day = weight_difference / days_between
    model.first_measurement.value + per_day * (Date.today - model.first_measurement.date)
  end

  def predict_value_at(date)
    predictor.predict_for(date - Date.today)
  end

  def predict_date_for(value)
    Date.today + predictor.inverse_predict_for(value).round.days
  end

  def predictor
    @predictor ||= LinearPredictor.new(measurements.map(&method(:days_since_today)), 
                                       measurements.map(&:value))
  end

  def days_since_today(measurement)
    (measurement.date - Date.today).to_i
  end
end


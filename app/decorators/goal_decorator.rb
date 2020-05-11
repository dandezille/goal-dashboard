class GoalDecorator < ApplicationDecorator
  include DateHelper
  delegate_all

  def description
    "#{'%.1f' % value}kg by #{h.format_date(date)}"
  end

  def target
    return '?' unless measurements.any?
    "#{'%.1f' % target_for_today}"
  end

  def target_delta
    return '?' unless measurements.any?
    delta = target_for_today - latest_measurement.value
    "#{'%.1f' % delta.abs}"
  end

  def target_delta_word
    return '?' unless measurements.any?
    delta = target_delta

    if delta.abs < 0.1
      'on target'
    elsif delta < 0
      'behind'
    else
      'ahead'
    end
  end

  def daily_goal
    return '?' unless measurements.any?

    days_between = (date - latest_measurement.date).to_i
    per_day = to_go / days_between
    "#{'%.2f' % per_day}"
  end

  def daily_historic
    return '?' unless measurements.count > 1
    "#{'%.2f' % -predictor.coefficients[1]}"
  end

  def latest_value
    return '?' unless measurements.any?
    latest_measurement.value
  end

  def latest_date
    return '?' unless measurements.any?
    delta = (Date.today - latest_measurement.date).to_i

    return 'today' if delta == 0
    return 'yesterday' if delta == 1
    "#{delta.abs} days ago"
  end

  def to_go
    return '?' unless measurements.any?
    latest_measurement.value - value
  end

  def projected_value
    return '?' unless measurements.count > 1
    "#{'%.1f' % predict_value_at(date)}"
  end

  def projected_date
    return '?' unless measurements.count > 1
    "#{h.format_date(predict_date_for(value))}"
  end

  def chart_definition
    measurements_data = measurements.map { |m| { x: m.date, y: m.value } }

    target_data = []
    if first_measurement
      target_data = [
        { x: first_measurement.date, y: first_measurement.value },
        { x: date, y: value }
      ]
    end

    prediction_data = []
    if measurements.count > 1
      prediction_data = [
        {
          x: first_measurement.date, y: predict_value_at(first_measurement.date)
        },
        { x: date, y: predict_value_at(date) }
      ]
    end

    {
      type: 'scatter',
      data: {
        datasets: [
          {
            label: 'Measurements',
            showLine: true,
            fill: false,
            backgroundColor: '#444190',
            borderColor: '#444190',
            data: measurements_data
          },
          { label: 'Target', showLine: true, fill: false, data: target_data },
          {
            label: 'Prediction',
            showLine: true,
            fill: false,
            backgroundColor: '#a3bffa',
            borderColor: '#a3bffa',
            data: prediction_data
          }
        ]
      },
      options: {
        legend: { display: false },
        scales: { xAxes: [{ type: 'time', time: { unit: 'day' } }] }
      }
    }.to_json
  end

  private

  def target_for_today
    days_between = (date - first_measurement.date).to_i
    delta = value - first_measurement.value
    per_day = delta / days_between
    first_measurement.value + per_day * (Date.today - first_measurement.date)
  end

  def predict_value_at(date)
    predictor.predict_for(date - Date.today)
  end

  def predict_date_for(value)
    Date.today + predictor.inverse_predict_for(value).round.days
  end

  def predictor
    @predictor ||=
      LinearPredictor.new(
        measurements.map(&:date).map(&method(:days_since_today)),
        measurements.map(&:value)
      )
  end
end

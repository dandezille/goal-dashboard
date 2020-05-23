class GoalDecorator < ApplicationDecorator
  include FormatHelper
  delegate_all

  def description
    "#{format_float 1, model.target}#{units} by #{h.format_date date}"
  end

  def target
    return '?' unless measurements.any?
    "#{format_float 1, calculations.target}"
  end

  def target_delta
    return '?' unless measurements.any?
    "#{format_float 1, calculations.target_delta.abs}"
  end

  def target_delta_word
    return '?' unless measurements.any?
    delta = calculations.target_delta
    target_delta_in_words(delta)
  end

  def daily_goal
    return '?' unless measurements.any?
    "#{format_float 2, calculations.daily_goal}"
  end

  def daily_historic
    return '?' unless measurements.count > 1
    "#{format_float 2, calculations.daily_historic}"
  end

  def latest_value
    return '?' unless measurements.any?
    "#{format_float 1, latest_measurement.value}"
  end

  def latest_date
    return '?' unless measurements.any?
    delta = calculations.latest_date_delta

    return 'today' if delta == 0
    return 'yesterday' if delta == 1
    "#{delta.abs} days ago"
  end

  def to_go
    return '?' unless measurements.any?
    "#{format_float 1, calculations.to_go}"
  end

  def projected_value
    return '?' unless measurements.count > 1
    "#{format_float 1, calculations.predict_value_at(date)}"
  end

  def projected_date
    return '?' unless measurements.count > 1
    "#{h.format_date(calculations.predict_date_for(model.target))}"
  end

  def chart_definition
    measurements_data = measurements.map { |m| { x: m.date, y: m.value } }

    target_data = []
    if first_measurement
      target_data = [
        { x: first_measurement.date, y: first_measurement.value },
        { x: date, y: target }
      ]
    end

    prediction_data = []
    if measurements.count > 1
      prediction_data = [
        {
          x: first_measurement.date,
          y: calculations.predict_value_at(first_measurement.date)
        },
        { x: date, y: calculations.predict_value_at(date) }
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

  def target_delta_in_words(delta)
    return 'on target' if delta.abs < 0.1
    return 'behind' if delta > 0
    'ahead'
  end
end

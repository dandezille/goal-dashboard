class GoalCalculatorError < StandardError; end

class GoalCalculator
  def initialize(goal)
    @goal = goal
  end

  def target
    check_for_measurements

    days_between = (@goal.date - @goal.first_measurement.date).to_i
    delta = @goal.target - @goal.first_measurement.value
    per_day = delta / days_between
    @goal.first_measurement.value +
      per_day * (Date.today - @goal.first_measurement.date)
  end

  def target_delta
    check_for_measurements
    @goal.latest_measurement.value - target
  end

  def to_go
    check_for_measurements
    @goal.latest_measurement.value - @goal.target
  end

  def daily_goal
    check_for_measurements
    days_between = (@goal.date - @goal.latest_measurement.date).to_i
    to_go / days_between
  end

  def daily_historic
    check_for_measurements
    -predictor.coefficients[1]
  end

  def latest_date_delta
    check_for_measurements
    (Date.today - @goal.latest_measurement.date).to_i
  end

  def predict_value_at(date)
    check_for_measurements
    predictor.predict_for(date - Date.today)
  end

  def predict_date_for(value)
    check_for_measurements
    Date.today + predictor.inverse_predict_for(value).round.days
  end

  private

  def check_for_measurements
    return if @goal.measurements.any?
    calling_method = caller[0][/`.*'/][1..-2]
    raise GoalCalculatorError.new "##{calling_method} requires measurements"
  end

  def predictor
    @predictor ||=
      LinearPredictor.new(
        @goal.measurements.map(&:date).map(&method(:days_since_today)),
        @goal.measurements.map(&:value)
      )
  end

  def days_since_today(date)
    (date.to_date - Date.today.to_date).to_i
  end
end

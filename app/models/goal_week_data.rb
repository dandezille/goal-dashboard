class GoalWeekData
  def initialize(start_date, end_date)
    @start_date = start_date
    @leading_padding = (start_date.wday - 1) % 7
    range = (start_date..end_date).count
    tailing_padding = 7 - (@leading_padding + range) % 7

    @days = Array.new(@leading_padding + range + tailing_padding, '')
  end

  def insert(date, value)
    index = (date - @start_date) + @leading_padding
    @days[index] = value
  end

  def as_weeks
    @days.each_slice(7).to_a
  end
end

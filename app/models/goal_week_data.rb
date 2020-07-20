class GoalWeekData
  def initialize(start_date, end_date)
    array_start = start_date.prev_occurring(:monday)
    array_end = end_date.next_occurring(:sunday)

    @start_date = array_start
    @days = (array_start..array_end).map { |date| Day.new date, ''  }
  end

  def insert(date, value)
    index = (date - @start_date)
    @days[index].value = value
  end

  def as_weeks
    @days.each_slice(7).to_a
  end

  Day = Struct.new(:date, :value)
end

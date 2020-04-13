class UserStatsDecorator < Draper::Decorator
  delegate_all

  def pace
    79.1
  end

  def daily_goal
    0.17
  end

  def current
    79.8
  end

  def to_go
    3.8
  end

  def projected
    77.5
  end

  def projected_date
    '30/04/20'
  end
end

module ApplicationHelper
  def format_date(date)
    date.strftime("%A #{date.day.ordinalize} %B")
  end
end

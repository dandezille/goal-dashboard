module ApplicationHelper
  def format_date(date)
    if not date.respond_to? :strftime
      date = Date.parse(date)
    end

    date.strftime("%A #{date.day.ordinalize} %B")
  end
end

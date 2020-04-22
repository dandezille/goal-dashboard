module ApplicationHelper
  def format_date(date)
    if not date.respond_to? :strftime
      date = Date.parse(date)
    end

    "#{date.day.ordinalize} #{date.strftime('%B')}"
  end
end

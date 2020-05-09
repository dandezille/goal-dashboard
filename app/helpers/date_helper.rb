module DateHelper
  def format_date(date)
    date = Date.parse(date) unless date.respond_to? :strftime
    "#{date.day.ordinalize} #{date.strftime('%B')}"
  end

  def days_since_today(date)
    (date.to_date - Date.today.to_date).to_i
  end
end

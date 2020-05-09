module DateHelper
  def format_date(date)
    date = Date.parse(date) unless date.respond_to? :strftime
    "#{date.day.ordinalize} #{date.strftime('%B')}"
  end
end

module FormatHelper
  def format_date(date)
    date = Date.parse(date) unless date.respond_to? :strftime
    "#{date.day.ordinalize} #{date.strftime('%B')}"
  end

  def format_float(decimal_places, number)
    format = "%.#{decimal_places}f"
    "#{format % number}"
  end
end

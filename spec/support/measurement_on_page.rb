class MeasurementOnPage < Struct.new(:params)
  include Capybara::DSL
  include DateHelper

  def create
    fill_in 'measurement_date', with: params[:date]
    fill_in 'measurement_value', with: params[:value]
    click_button 'Add'
  end

  def delete
    page.find('.measurement') { |element|
      match_measurement(element)
    }.click_button 'Delete'
  end

  def visible?
    page.has_css?('.measurement') { |element| match_measurement(element) }
  end

  private

  def match_measurement(element)
    element.has_css?('.value', text: params[:value]) &&
      element.has_css?('.date', text: format_date(params[:date]))
  end
end

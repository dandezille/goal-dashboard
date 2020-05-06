class MeasurementOnPage < Struct.new(:params)
  include Capybara::DSL
  include ApplicationHelper

  def create
    fill_in 'measurement_date', with: params[:date]
    fill_in 'measurement_value', with: params[:value]
    click_button 'Add'
  end

  def delete
    measurement_element.first.click_button 'Delete'
  end

  def visible?
    measurement_element.one?
  end

  private

  def measurement_element
    page.all('.measurement').select do |element|
      element.has_css?('.value', text: params[:value]) &&
        element.has_css?('.date', text: format_date(params[:date]))
    end
  end
end

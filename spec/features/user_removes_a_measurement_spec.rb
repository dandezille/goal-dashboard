require 'rails_helper'

RSpec.feature 'User removes a measurement' do
  before { sign_in }

  scenario 'it is deleted' do
    measurement = create(:measurement)
    visit root_path
    within("#measurement_#{measurement.id}") do
      click_on 'Delete'
    end
    expect(page).to have_css('.flash.notice', text: 'Measurement removed')
    expect(Measurement.count).to eq(0)
  end

  def sign_in
    @current_user = create(:user)
    visit root_path(as: @current_user)
  end
end

require 'rails_helper'

RSpec.feature 'User removes a measurement' do
  before { sign_in }

  scenario 'it is deleted' do
    goal = create(:goal, :with_measurements, user: current_user)
    visit root_path

    expect do
      within("#measurement_#{goal.measurements.first.id}") { click_on 'Delete' }
    end.to change(Measurement, :count).by(-1)

    expect(page).to have_flash_notice('Measurement removed')
  end
end

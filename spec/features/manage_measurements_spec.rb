require 'rails_helper'

RSpec.feature 'manage measurements' do
  before { sign_in }
  let!(:goal) { create(:goal, :with_measurements, user: current_user) }

  scenario 'add new measurement' do
    visit root_path

    expect do
      within('#new_measurement') do
        fill_form_and_submit(:measurement, attributes_for(:measurement))
      end
    end.to change(Measurement, :count).by(1)

    expect(page).to have_flash_notice('Measurement created')
  end

  scenario 'it is deleted' do
    visit root_path

    expect do
      within("#measurement_#{goal.measurements.first.id}") { click_on 'Delete' }
    end.to change(Measurement, :count).by(-1)

    expect(page).to have_flash_notice('Measurement removed')
  end
end

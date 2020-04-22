require 'rails_helper'

RSpec.feature 'User removes a measurement' do
  before { sign_in }

  scenario 'it is deleted' do
    measurement = create(:measurement, user: current_user)
    visit root_path

    expect do
      within("#measurement_#{measurement.id}") do
        click_on 'Delete'
      end
    end.to change(Measurement, :count).by(-1)

    expect(page).to have_flash_notice('Measurement removed')
  end
end

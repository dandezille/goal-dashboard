require 'rails_helper'

RSpec.feature 'User adds a measurement' do
  before { sign_in_as create(:user, :with_goal) }

  scenario 'it is created' do
    visit root_path

    expect do
      within('#new_measurement') do
        expect(page).to have_field 'measurement_date',
                   with: Date.today.strftime('%Y-%m-%d')

        fill_form_and_submit(:measurement, attributes_for(:measurement))
      end
    end.to change(Measurement, :count).by(1)

    expect(page).to have_flash_notice('Measurement created')
  end
end

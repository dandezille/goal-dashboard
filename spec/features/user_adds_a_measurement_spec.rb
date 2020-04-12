require 'rails_helper'

RSpec.feature 'User adds a measurement' do
  before { sign_in }

  scenario 'it is created' do
    visit root_path
    fill_form_and_submit(:measurement, attributes_for(:measurement))
    expect(page).to have_flash_notice('Measurement created')
    expect(Measurement.count).to eq(1)
  end
end

require 'rails_helper'

RSpec.feature 'User adds a measurement' do
  scenario 'it is created' do
    visit root_path
    fill_form_and_submit(:measurement, attributes_for(:measurement))
    expect(page).to have_css('.flash.notice', text: 'New measurement created')
    expect(Measurement.count).to eq(1)
  end
end

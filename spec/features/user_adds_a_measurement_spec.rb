require 'rails_helper'

RSpec.feature 'User adds a measurement' do
  scenario 'they see the measurement on the dashboard' do
    visit root_path
    fill_form_and_submit(:measurement, attributes_for(:measurement))
    expect(page).to have_css('.entry', text: '79.2')
  end
end

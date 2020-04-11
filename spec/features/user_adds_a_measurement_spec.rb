require 'rails_helper'

RSpec.feature "User add a measurement" do
  scenario 'they see the measurement on the dashboard' do
    visit root_path
    fill_form(:measurement, { date: '10/04/20', value: '79.2' })
    click_on 'Add'
    expect(page).to have_css('.entry', text: '79.2')
  end
end

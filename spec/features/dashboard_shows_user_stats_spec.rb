require 'rails_helper'

RSpec.feature 'Dashboard shows user stats' do
  before { sign_in }

  scenario 'it shows current measurement' do
    measurement = create(:measurement, user: current_user)
    visit root_path
    expect(page).to have_current_value(measurement.value)
  end

  def have_current_value(value)
    have_css '#progress #current #value', text: value.to_s
  end
end
require 'rails_helper'

RSpec.feature 'manage measurements' do
  let(:goal) { create(:goal, :with_measurements) }
  let(:user) { goal.user }

  before { visit goal_path(goal, as: user) }

  scenario 'new measurement date is set to today' do
    within('#new_measurement') do
      expect(page).to have_field 'measurement_date',
                 with: Date.today.strftime('%Y-%m-%d')
    end
  end

  scenario 'create a new measurement' do
    measurement = measurement_on_page
    measurement.create

    expect(measurement).to be_visible
    expect(page).to have_flash_notice('Measurement created')
  end

  scenario 'view only measurements the user has created' do
    measurement = measurement_on_page
    measurement.create

    sign_in_as create(:user)
    visit root_path
    expect(measurement).not_to be_visible
  end

  scenario 'delete a measurement' do
    measurement = measurement_on_page
    measurement.create
    measurement.delete

    expect(measurement).not_to be_visible
    expect(page).to have_flash_notice('Measurement removed')
  end

  def measurement_on_page
    MeasurementOnPage.new(attributes_for(:measurement))
  end
end

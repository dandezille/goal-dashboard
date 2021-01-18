require 'rails_helper'

RSpec.feature 'manage measurements' do
  let(:goal) { create(:goal, :with_measurements) }
  let(:user) { goal.user }

  before { visit goal_path(goal, as: user) }

  scenario 'create a new measurement' do
    visit new_goal_measurement_path(goal)

    within('#new_measurement') do
      expect(page).to have_field 'measurement_date',
                 with: Date.today.strftime('%Y-%m-%d')
    end

    measurement = measurement_on_page
    measurement.create

    expect(page).to have_flash_notice('Measurement created')

    visit goal_measurements_path(goal, as: user)
    expect(measurement).to be_visible
  end

  scenario 'view only measurements the user has created' do
    visit new_goal_measurement_path(goal)

    measurement = measurement_on_page
    measurement.create

    sign_in_as create(:user)
    visit root_path
    expect(measurement).not_to be_visible
  end

  scenario 'delete a measurement' do
    visit new_goal_measurement_path(goal)

    measurement = measurement_on_page
    measurement.create

    visit goal_measurements_path(goal, as: user)
    measurement.delete

    expect(page).to have_flash_notice('Measurement removed')

    visit goal_measurements_path(goal, as: user)
    expect(measurement).not_to be_visible
  end

  def measurement_on_page
    MeasurementOnPage.new(attributes_for(:measurement))
  end
end

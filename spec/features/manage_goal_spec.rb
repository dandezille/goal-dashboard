require 'rails_helper'

RSpec.feature 'manage goal' do
  before { sign_in }

  scenario 'with no goal' do
    visit root_path
    goal = goal_on_page
    goal.create

    expect(goal).to be_visible
    expect(page).to have_flash_notice('Goal set')
  end

  scenario 'with an existing goal' do
    create(:goal, user: current_user)
    visit root_path
    goal = goal_on_page
    goal.create

    expect(goal).to be_visible
    expect(page).to have_flash_notice('Goal updated')
  end

  def goal_on_page
    GoalOnPage.new(attributes_for(:goal))
  end
end

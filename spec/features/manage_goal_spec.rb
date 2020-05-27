require 'rails_helper'

RSpec.feature 'manage goals' do
  let(:goal_page) { GoalOnPage.new }
  let(:user) { create(:user) }

  scenario 'create a goal' do
    goal = attributes_for(:goal)

    visit root_path(as: user)
    goal_page.create goal

    expect(goal_page).to have_goal goal
    expect(page).to have_flash_notice 'Goal set'
  end

  scenario 'edit a goal' do
    original = attributes_for(:goal)
    new = attributes_for(:goal)

    visit root_path(as: user)
    goal_page.create original
    goal_page.change_to new

    expect(goal_page).to have_goal new
    expect(page).to have_flash_notice('Goal updated')
  end
end

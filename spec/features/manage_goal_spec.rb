require 'rails_helper'

RSpec.feature 'manage goals' do
  let(:goal_page) { GoalOnPage.new }
  let(:user) { create(:user) }

  scenario 'view goals' do
    goals = create_list(:goal, 3, user: user)

    visit root_path(as: user)
    within '.header' do
      click_on 'Goals'
    end

    expect(page).to have_css('.card-title', text: "Goals")

    goals.each do |goal|
      expect(page).to have_css("[data-goal-id=\"#{goal.id}\"]", text: goal.title)
    end
  end

  scenario 'create a goal' do
    goal = attributes_for(:goal)

    visit new_goal_path(as: user)
    goal_page.create goal

    expect(goal_page).to have_goal goal
    expect(page).to have_flash_notice 'Goal set'
  end

  scenario 'view a goal' do
    goal = create(:goal, user: user)

    visit goals_path(as: user)
    within "[data-goal-id=\"#{goal.id}\"]" do
      click_on 'a'
    end

    expect(page).to have_current_path(goal_path(goal))
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

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

  context 'without a goal' do
    scenario 'create a goal' do
      goal = attributes_for(:goal)

      visit root_path(as: user)
      within '.header' do
        click_on 'Goals'
      end

      expect(page).to have_current_path(new_goal_path)
      goal_page.create goal
      expect(page).to have_flash_notice 'Goal set'

      click_on goal[:title]
      expect(goal_page).to have_goal goal
    end
  end

  context 'with a goal' do
    scenario 'create a goal' do
      create(:goal, user: user)
      goal = attributes_for(:goal)

      visit root_path(as: user)
      within '.header' do
        click_on 'Goals'
      end

      expect(page).to have_current_path(goals_path)

      click_on 'Create goal'
      goal_page.create goal
      expect(page).to have_flash_notice 'Goal set'

      click_on goal[:title]
      expect(goal_page).to have_goal goal
    end
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
    click_on 'Goals'
    goal_page.create original

    click_on original[:title]
    goal_page.change_to new
    expect(page).to have_flash_notice('Goal updated')
    expect(goal_page).to have_goal new
  end
end

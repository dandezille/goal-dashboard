require 'rails_helper'

RSpec.feature 'manage goals' do
  let(:user) { create(:user) }
  let(:attributes) { attributes_for(:goal) }
  let(:goal_on_page) { GoalOnPage.new(attributes) }

  scenario 'view goals' do
    active_goal = create(:goal, user: user)
    complete_goal = create(:goal, user: user, date: Date.yesterday)

    navigate_to_goals
    expect(page).to have_active_goal(active_goal.title)
    expect(page).to have_complete_goal(complete_goal.title)
  end

  def have_active_goal(title)
    have_css '.active-goals', text: title
  end

  def have_complete_goal(title)
    have_css '.complete-goals', text: title
  end

  context 'create goal' do
    scenario 'with no goals' do
      visit root_path(as: user)
      expect(page).to have_css('.card-title', text: 'Create Goal')
      goal_on_page.create

      expect(goal_on_page).to be_visible
      expect(page).to have_flash_notice('Goal set')
    end

    scenario 'with existing goals' do
      goal = user.goals.create!(attributes)

      navigate_to_goals
      click_on 'Create goal'

      expect(page).to have_css('.card-title', text: 'Create Goal')
      goal_on_page.create

      expect(goal_on_page).to be_visible
      expect(page).to have_flash_notice('Goal set')
    end
  end

  scenario 'view goal' do
    goal = user.goals.create!(attributes)

    navigate_to_goals
    click_on goal.title

    expect(goal_on_page).to be_visible
  end

  scenario 'edit goal' do
    goal = create(:goal, user: user)

    navigate_to_goals
    click_on goal.title

    goal_on_page.edit

    expect(goal_on_page).to be_visible
    expect(page).to have_flash_notice('Goal updated')
  end

  def navigate_to_goals
    visit root_path(as: user)
    within '.header' do
      click_on 'Goals'
    end
    expect(page).to have_css('.card-title', text: 'Goals')
  end
end

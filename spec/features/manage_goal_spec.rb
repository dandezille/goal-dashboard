require 'rails_helper'

RSpec.feature 'manage goal' do
  before { sign_in }

  scenario 'for the first time' do
    new_goal = fill_goal

    expect(page).to have_flash_notice('Goal set')
    expect(current_user.goal.value).to eq(new_goal[:value])
    expect(current_user.goal.date).to eq(Date.parse(new_goal[:date]))
  end

  scenario 'when goal exists' do
    create(:goal, user: current_user)
    new_goal = fill_goal

    expect(page).to have_flash_notice('Goal updated')
    expect(current_user.goal.value).to eq(new_goal[:value])
    expect(current_user.goal.date).to eq(Date.parse(new_goal[:date]))
  end

  def fill_goal
    goal_attributes = attributes_for(:goal)
    visit root_path
    within('#goal_form') { fill_form_and_submit(:goal, goal_attributes) }
    current_user.reload

    goal_attributes
  end

  def have_goal(goal)
    have_css '#goal', text: "#{'%.1f' % goal[:value]} by #{goal[:date]}"
  end
end

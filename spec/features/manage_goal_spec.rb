require 'rails_helper'

RSpec.feature 'manage goals' do
  let(:user) { create(:user) }

  scenario 'view goals' do
    goals = create_list(:goal, 3, user: user)

    visit root_path(as: user)
    within '.header' do
      click_on 'Goals'
    end

    expect(page).to have_css('.card-title', text: 'Goals')

    goals.each do |goal|
      expect(page).to have_content goal.title
    end
  end

  scenario 'with no goal' do
    visit root_path(as: user)
    expect(page).to have_css('.card-title', text: 'Create Goal')

    goal = goal_on_page
    goal.create

    expect(goal).to be_visible
    expect(page).to have_flash_notice('Goal set')
  end

  scenario 'with an existing goal' do
    goal = create(:goal, user: user)
    visit root_path(as: user)
    click_on goal.title

    goal = goal_on_page
    goal.edit

    expect(goal).to be_visible
    expect(page).to have_flash_notice('Goal updated')
  end

  def goal_on_page
    GoalOnPage.new(attributes_for(:goal))
  end
end

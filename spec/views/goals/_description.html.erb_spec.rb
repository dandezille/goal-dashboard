require 'rails_helper'

RSpec.describe 'goals/_description.html.erb' do
  it 'displays a summary of the goal' do
    goal = build(:goal, id: 0)
    render 'goals/description', goal: goal 
    expect(rendered).to have_content goal.units
  end
end

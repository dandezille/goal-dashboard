require 'rails_helper'

RSpec.describe GoalDecorator do
  describe '#current' do
    context 'with measurements' do
      it 'returns latest measurement value' do
        goal = create(:goal)
        create(:measurement, goal: goal, date: Date.yesterday, value: 80)
        create(:measurement, goal: goal, date: Date.today, value: 70)

        expect(goal.decorate.current).to eq(70)
      end
    end

    context 'without measurements' do
      it 'handles missing measurements' do
        expect(create(:goal).decorate.current).to eq('?')
      end
    end
  end

end

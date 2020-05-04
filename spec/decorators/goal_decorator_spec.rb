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

  describe '#chart_definition' do
    it 'returns json chart data' do
      goal = create(:goal)
      create(:measurement, goal: goal, date: Date.yesterday, value: 60)
      create(:measurement, goal: goal, date: Date.today, value: 55)

      expect(goal.decorate.chart_definition).to include_json(
        type: 'scatter',
        data: {
          datasets: [
            {
              data:[
                { x: Date.today.strftime('%Y-%m-%d'), y: '55.0' },
                { x: Date.yesterday.strftime('%Y-%m-%d'), y: '60.0' }
              ]
            }
          ]
        }
      )
    end
  end

end

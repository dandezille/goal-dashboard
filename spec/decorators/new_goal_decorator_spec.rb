require 'rails_helper'

RSpec.describe GoalDecorator do
  let(:calculator) { instance_double(GoalCalculator) }
  let(:value) { instance_double(Float) }
  let(:date) { instance_double(DateTime) }
  let(:measurements) { [] }
  let(:goal) do
    GoalDecorator.decorate(
      instance_double(
        Goal,
        date: date,
        value: value,
        measurements: measurements,
        calculations: calculator,
        latest_measurement: double(value: 65)
      )
    )
  end

  describe '#description' do
    let(:value) { 72.32 }
    let(:date) { '2020-05-02' }

    it 'describes the goal' do
      expect(goal.description).to eq('72.3kg by 2nd May')
    end
  end

  context 'without measurements' do
    describe '#target' do
      it 'returns ?' do
        expect(goal.target).to eq('?')
      end
    end

    describe '#target_delta' do
      it 'returns ?' do
        expect(goal.target_delta).to eq('?')
      end
    end

    describe '#target_delta_word' do
      it 'returns ?' do
        expect(goal.target_delta_word).to eq('?')
      end
    end

    describe '#daily_goal' do
      it 'returns ?' do
        expect(goal.daily_goal).to eq('?')
      end
    end

    describe '#daily_historic' do
      it 'returns ?' do
        expect(goal.daily_historic).to eq('?')
      end
    end

    describe '#latest_value' do
      it 'returns ?' do
        expect(goal.latest_value).to eq('?')
      end
    end

    describe '#latest_date' do
      it 'returns ?' do
        expect(goal.latest_date).to eq('?')
      end
    end

    describe '#to_go' do
      it 'returns ?' do
        expect(goal.to_go).to eq('?')
      end
    end

    describe '#projected_value' do
      it 'returns ?' do
        expect(goal.projected_value).to eq('?')
      end
    end

    describe '#projected_date' do
      it 'returns ?' do
        expect(goal.projected_date).to eq('?')
      end
    end
  end

  context 'with one measurement' do
    let(:measurements) { [double] }

    describe '#daily_historic' do
      it 'returns ?' do
        expect(goal.daily_historic).to eq('?')
      end
    end

    describe '#projected_value' do
      it 'returns ?' do
        expect(goal.projected_value).to eq('?')
      end
    end

    describe '#projected_date' do
      it 'returns ?' do
        expect(goal.projected_date).to eq('?')
      end
    end
  end

  context 'with multiple measurements' do
    let(:measurements) { [double, double] }

    describe '#target' do
      it 'formats calculated value' do
        expect(calculator).to receive(:target).and_return(63.3)
        expect(goal.target).to eq('63.3')
      end
    end

    describe '#target_delta' do
      it 'formats calculated value' do
        expect(calculator).to receive(:target_delta).and_return(-1.7)
        expect(goal.target_delta).to eq('1.7')
      end
    end

    describe '#target_delta_word' do
      it 'returns on target' do
        expect(calculator).to receive(:target_delta).and_return(0)
        expect(goal.target_delta_word).to eq('on target')
      end

      it 'returns behind' do
        expect(calculator).to receive(:target_delta).and_return(1)
        expect(goal.target_delta_word).to eq('behind')
      end

      it 'returns ahead' do
        expect(calculator).to receive(:target_delta).and_return(-1)
        expect(goal.target_delta_word).to eq('ahead')
      end
    end

    describe '#daily_goal' do
      it 'returns loss required per day to hit target' do
        expect(calculator).to receive(:daily_goal).and_return(3.33)
        expect(goal.daily_goal).to eq('3.33')
      end
    end

    describe '#daily_historic' do
      it 'returns historic loss per day' do
        expect(calculator).to receive(:daily_historic).and_return(0.5)
        expect(goal.daily_historic).to eq('0.50')
      end
    end

    describe '#latest_value' do
      it 'returns latest measurement value' do
        expect(goal).to receive(:latest_measurement).and_return(
          double(value: 65)
        )
        expect(goal.latest_value).to eq('65.0')
      end
    end

    describe '#latest_date' do
      it 'returns today' do
        expect(calculator).to receive(:latest_date_delta).and_return(0)
        expect(goal.latest_date).to eq('today')
      end

      it 'returns yesterday' do
        expect(calculator).to receive(:latest_date_delta).and_return(1)
        expect(goal.latest_date).to eq('yesterday')
      end

      it 'returns days ago' do
        expect(calculator).to receive(:latest_date_delta).and_return(2)
        expect(goal.latest_date).to eq('2 days ago')
      end
    end

    describe '#to_go' do
      it 'returns latest measurement minus goal' do
        expect(calculator).to receive(:to_go).and_return(10.0)
        expect(goal.to_go).to eq('10.0')
      end
    end

    describe '#projected_value' do
      it 'predicts value at goal end date' do
        expect(calculator).to receive(:predict_value_at).with(date).and_return(
          64
        )
        expect(goal.projected_value).to eq('64.0')
      end
    end

    describe '#projected_date' do
      it 'predicts date at goal end value' do
        expect(calculator).to receive(:predict_date_for).with(value).and_return(
          Date.parse('2020-05-01')
        )
        expect(goal.projected_date).to eq('1st May')
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
              data: [
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

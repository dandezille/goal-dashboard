require 'rails_helper'

RSpec.describe FormatHelper do
  describe 'format_date' do
    let(:date_string) { '2020-05-02' }

    it 'handles date input' do
      date = Date.parse(date_string)
      expect(helper.format_date(date)).to eq('2nd May')
    end

    it 'handles non date input' do
      expect(helper.format_date(date_string)).to eq('2nd May')
    end
  end

  describe 'days_since_today' do
    it { expect(helper.days_since_today(2.days.since)).to eq(2) }
    it { expect(helper.days_since_today(1.days.since)).to eq(1) }
    it { expect(helper.days_since_today(Date.today)).to eq(0) }
    it { expect(helper.days_since_today(1.days.ago)).to eq(-1) }
    it { expect(helper.days_since_today(2.days.ago)).to eq(-2) }
  end
end

require 'rails_helper'

RSpec.describe DateHelper do
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
end

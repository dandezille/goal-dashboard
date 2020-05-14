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

  describe 'format_float' do
    let(:number) { 18.247 }

    it 'does one decimal place' do
      expect(helper.format_float(1, number)).to eq('18.2')
    end

    it 'does two decimal places' do
      expect(helper.format_float(2, number)).to eq('18.25')
    end
  end
end

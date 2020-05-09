require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the DateHelperHelper. For example:
#
# describe DateHelperHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
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

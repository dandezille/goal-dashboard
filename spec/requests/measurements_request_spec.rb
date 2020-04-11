require 'rails_helper'

RSpec.describe "Measurements" do

  describe "POST /create" do
    it "returns http success" do
      post "/measurements/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /destroy" do
    it "returns http success" do
      get "/measurements/destroy"
      expect(response).to have_http_status(:success)
    end
  end

end

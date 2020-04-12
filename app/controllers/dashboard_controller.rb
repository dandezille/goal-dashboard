class DashboardController < ApplicationController
  before_action :require_login

  def index
    @measurement = Measurement.new
    @measurements = Measurement.all
  end
end

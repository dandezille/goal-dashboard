class DashboardController < ApplicationController
  before_action :require_login

  def index
    @measurement = Measurement.new
    @measurements = current_user.measurements
    @current_measurement = @measurements.first
  end
end

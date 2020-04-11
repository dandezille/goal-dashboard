class DashboardController < ApplicationController
  def index
    @measurement = Measurement.new
    @measurements = Measurement.all
  end
end

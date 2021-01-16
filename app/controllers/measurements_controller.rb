class MeasurementsController < ApplicationController
  before_action :require_login
  before_action -> { require_goal(:goal_id) }, only: [:index, :create, :table]
  before_action :require_measurement, only: :destroy

  def table
    @weeks = @goal.measurements_by_week
    render layout: false
  end

  def index
    @measurements = @goal.measurements.reverse
    render layout: false
  end

  def create
    if create_measurement
      flash[:notice] = 'Measurement created'
    else
      flash[:alert] = @measurement.errors.messages
    end

    redirect_to @goal
  end

  def destroy
    @measurement.destroy
    flash[:notice] = 'Measurement removed'
    redirect_to @measurement.goal
  end

  private

  def create_measurement
    @measurement = @goal.measurements.create(measurement_params)
    @measurement.save
  end

  def measurement_params
    params.require(:measurement).permit(:date, :value)
  end
end

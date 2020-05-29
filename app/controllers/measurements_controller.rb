class MeasurementsController < ApplicationController
  before_action :require_login
  before_action { require_goal(:goal_id) }
  before_action :require_measurement, only: :destroy

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
    redirect_to @goal
  end

  private

  def find_measurement
    @measurement = Measurement.find(params[:id])
  end

  def create_measurement
    @measurement = @goal.measurements.create(measurement_params)
    @measurement.save
  end

  def measurement_params
    params.require(:measurement).permit(:date, :value)
  end
end

class MeasurementsController < ApplicationController
  before_action :require_login
  before_action :find_measurement, only: :destroy

  def create
    if create_measurement
      flash[:notice] = 'Measurement created'
    else
      flash[:alert] = @measurement.errors.messages
    end

    redirect_to root_path
  end

  def destroy
    if @measurement.goal.user == current_user
      @measurement.destroy
      flash[:notice] = 'Measurement removed'
    else
      flash[:alert] = 'Failed to remove measurement'
    end

    redirect_to root_path
  end

  private

  def find_measurement
    @measurement = Measurement.find(params[:id])
  end

  def create_measurement
    @measurement = current_user.goal.measurements.create(measurement_params)
    @measurement.save
  end

  def measurement_params
    params.require(:measurement).permit(:date, :value)
  end
end

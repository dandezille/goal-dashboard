class MeasurementsController < ApplicationController
  before_action :require_login

  def create
    if create_measurement
      flash[:notice] = 'Measurement created'
    else
      flash[:alert] = @measurement.errors.messages
    end

    redirect_to root_path
  end

  def destroy
    measurement = Measurement.find(params[:id])
    if measurement.user == current_user
      measurement.destroy
      flash[:notice] = 'Measurement removed'
    else
      flash[:alert] = 'Failed to remove measurement'
    end

    redirect_to root_path
  end

  private

  def create_measurement
    @measurement = current_user.measurements.create(measurement_params)
    @measurement.save
  end

  def measurement_params
    params.require(:measurement).permit(:date, :value)
  end
end

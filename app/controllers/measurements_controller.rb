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
    measurement.destroy
    flash[:notice] = 'Measurement removed'
    redirect_to root_path
  end

  private

  def create_measurement
    @measurement = Measurement.new(measurement_params)
    @measurement.save
  end

  def measurement_params
    params.require(:measurement).permit(:date, :value)
  end
end

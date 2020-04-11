class MeasurementsController < ApplicationController
  def create
    measurement = Measurement.new(measurement_params)
    measurement.save
    redirect_to root_path
  end

  def destroy
    measurement = Measurement.find(params[:id])
    measurement.delete
    redirect_to root_path
  end

  private

  def measurement_params
    params.require(:measurement).permit(:date, :value)
  end
end

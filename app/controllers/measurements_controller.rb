class MeasurementsController < ApplicationController
  def create
    measurement = Measurement.new(measurement_params)
    measurement.save
    redirect_to root_path
  end

  def destroy
  end

  private

  def measurement_params
    params.require(:measurement).permit(:date, :value)
  end
end

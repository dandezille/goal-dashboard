class MeasurementsController < ApplicationController
  before_action :require_login
  before_action :find_goal
  before_action :user_authorised
  before_action :find_measurement, only: :destroy

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

  def find_goal
    @goal = Goal.find(params[:goal_id])
  end

  def user_authorised
    if @goal.user != current_user
      redirect_to root_path
      flash[:alert] = 'Action not authorised'
    end
  end

  def create_measurement
    @measurement = @goal.measurements.create(measurement_params)
    @measurement.save
  end

  def measurement_params
    params.require(:measurement).permit(:date, :value)
  end
end

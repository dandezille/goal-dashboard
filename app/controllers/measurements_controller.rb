class MeasurementsController < ApplicationController
  before_action :require_login
  before_action :find_measurement, only: :destroy
  before_action :find_goal, only: :create

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

  def find_goal
    @goal = Goal.find(params[:goal_id])
  end

  def create_measurement
    if @goal.user != current_user
      @measurement = Measurement.new
      @measurement.errors[:base] << 'User does not own this goal'
      return false
    end

    @measurement = @goal.measurements.create(measurement_params)
    @measurement.save
  end

  def measurement_params
    params.require(:measurement).permit(:date, :value)
  end
end

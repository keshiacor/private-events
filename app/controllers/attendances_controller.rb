class AttendancesController < ApplicationController
  before_action :authenticate_user!

  def create
    @attendance = current_user.attendances.build(attendance_params)

    if @attendance.save
      redirect_to event_path(@attendance.attended_event), notice: "You've successfully registered for this event!"
    else
      redirect_back fallback_location: events_path, alert: @attendance.errors.full_messages.to_sentence, status: :unprocessable_entity
    end
  end

  private
  def attendance_params
    params.require(:attendance).permit(:attended_event_id)
  end
end

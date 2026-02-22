class AttendancesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event, only: [ :create ]
  before_action :set_attendance, only: [ :destroy ]
  before_action :authorize_event_access, only: [ :create ]
  before_action :authorize_attendance_cancellation, only: [ :destroy ]

  def create
    @attendance = current_user.attendances.build(attendance_params)

    if @attendance.save
      redirect_to event_path(@attendance.attended_event), notice: "You've successfully registered for this event!"
    else
      redirect_back fallback_location: events_path, alert: @attendance.errors.full_messages.to_sentence, status: :unprocessable_entity
    end
  end

  def destroy
    event = @attendance.attended_event
    @attendance.destroy
    redirect_to event_path(event), notice: "You've successfully cancelled your attendance."
  end

  private

  def set_event
    @event = Event.find(params[:attendance][:attended_event_id])
  end

  def set_attendance
    @attendance = current_user.attendances.find(params[:id])
  end

  def authorize_event_access
    unless can_access_event?(@event)
      redirect_to events_path, alert: "You don't have access to this event."
    end
  end

  def authorize_attendance_cancellation
    if @attendance.attended_event.creator == current_user
      redirect_back fallback_location: events_path, alert: "Event creators cannot cancel their attendance."
    end
  end

  def can_access_event?(event)
    event.creator == current_user || event.invited_users.include?(current_user)
  end

  def attendance_params
    params.require(:attendance).permit(:attended_event_id)
  end
end

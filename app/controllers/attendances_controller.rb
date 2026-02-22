class AttendancesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event, only: [ :create ]
  before_action :authorize_event_access, only: [ :create ]

  def create
    @attendance = current_user.attendances.build(attendance_params)

    if @attendance.save
      redirect_to event_path(@attendance.attended_event), notice: "You've successfully registered for this event!"
    else
      redirect_back fallback_location: events_path, alert: @attendance.errors.full_messages.to_sentence, status: :unprocessable_entity
    end
  end

  # TODO: add a destroy action so users can unattend events by adding a cancel attendance button on the event show page that only appears if the user is already marked as attending the event. This destroy action should find the attendance by the current_user and the event id and then destroy that attendance record.

  private

  def set_event
    @event = Event.find(params[:attendance][:attended_event_id])
  end

  def authorize_event_access
    unless can_access_event?(@event)
      redirect_to events_path, alert: "You don't have access to this event."
    end
  end

  def can_access_event?(event)
    event.creator == current_user || event.invited_users.include?(current_user)
  end

  def attendance_params
    params.require(:attendance).permit(:attended_event_id)
  end
end

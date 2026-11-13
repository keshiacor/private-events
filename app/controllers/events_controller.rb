class EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event, only: [ :show, :destroy, :edit, :update ]
  before_action :authorize_accessing_event, only: [ :show ]
  before_action :authorize_creator, only: [ :edit, :update, :destroy ]

  def index
    @events = Event.all.order(event_date: :asc)
  end

  def show
    # Get all users except creator and already invited users
    @available_users = User.where.not(id: @event.creator_id)
                           .where.not(id: @event.invited_users.pluck(:id))
                           .order(:email)
  end

  def new
    @event = Event.new
  end

  def create
    # passing the event params to the current_user's created_events association to automatically set the creator_id
    @event = current_user.created_events.build(event_params)

    if @event.save
      redirect_to @event, notice: "Event was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @event.update(event_params)
      redirect_to @event, notice: "Event was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @event.destroy
    redirect_to events_path, notice: "Event was successfully deleted."
  end

  private
  def set_event
    @event = Event.find(params[:id])
  end

  def authorize_creator
    unless @event.creator == current_user
      redirect_to events_path, alert: "Only the event creator can change this event."
    end
  end

  def authorize_accessing_event
    unless @event.accessible_by?(current_user)
      redirect_back fallback_location: events_path, alert: "You are not authorized to view this event."
    end
  end

  def event_params
    params.require(:event).permit(:name, :location, :event_date)
  end
end

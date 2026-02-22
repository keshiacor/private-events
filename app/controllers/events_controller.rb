class EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event, only: [ :show, :destroy, :edit, :update ]
  before_action :authorize_accessing_event, only: [ :show ]

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
    @event = Event.find(params[:id])
    unless @event.creator == current_user
      redirect_to events_path, alert: "Only the event creator can edit this event."
    end
  end

  def update
    if @event.creator == current_user
      if @event.update(event_params)
        redirect_to @event, notice: "Event was successfully updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end
  end

  def destroy
    if @event.creator == current_user
      @event.destroy
      redirect_to events_path, notice: "Event was successfully deleted."
    end
  end

  # TODO: add the ability to make events private and only invited users can register to attend.
  # the event creator can invite users to attend by clicking an invite button on the event show page that prompts them to add a user by selecting a user from  a dropdown list of all users.
  # When the event creator invites a user to attend an event, it should allow the event to show up on their events index page and allow them to click on the event to mark themselves as attending.

  private
  def set_event
    @event = Event.find(params[:id])
  end

  def authorize_accessing_event
    unless access_allowed?(@event)
      redirect_to events_path, alert: "You are not authorized to view this event."
    end
  end

  def access_allowed?(event)
     event.creator == current_user || event.invited_users.include?(current_user)
  end

  def event_params
    params.require(:event).permit(:name, :location, :event_date)
  end
end

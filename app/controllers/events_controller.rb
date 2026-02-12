class EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event, only: [ :show ]

  def index
    @events = Event.all
  end

  def show
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



  private
  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:name, :location, :event_date)
  end
end

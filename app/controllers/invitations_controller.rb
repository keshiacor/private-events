class InvitationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event
  before_action :authorize_event_creator, only: [ :create, :destroy ]

  def create
    @user = User.find(params[:user_id])

    # Prevent creator from inviting themselves
    if @user == current_user
      redirect_to @event, alert: "You cannot invite yourself to your own event."
      return
    end

    @invitation = @event.invitations.build(user: @user)

    if @invitation.save
      redirect_to @event, notice: "#{@user.email} has been invited to the event."
    else
      redirect_to @event, alert: "Unable to invite user. They may already be invited."
    end
  end

  def destroy
    @invitation = @event.invitations.find(params[:id])
    @invitation.destroy
    redirect_to @event, notice: "Invitation has been removed."
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def authorize_event_creator
    unless @event.creator == current_user
      redirect_to events_path, alert: "Only the event creator can manage invitations."
    end
  end
end

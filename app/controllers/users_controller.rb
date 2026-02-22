class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [ :show ]

  def show
    # Get events user created or is invited to
    @accessible_events = Event.left_joins(:invitations)
                              .where("events.creator_id = ? OR invitations.user_id = ?",
                                     current_user.id, current_user.id)
                              .distinct
  end

  private

  def set_user
     @user = current_user
  end
end

require "rails_helper"

RSpec.describe "Attendances", type: :request do
  let(:creator) { create(:user) }
  let(:invitee) { create(:user) }
  let(:stranger) { create(:user) }
  let!(:event) { create(:event, creator: creator) }

  before { create(:invitation, event: event, user: invitee) }

  describe "POST /attendances" do
    it "lets an invited user register for the event" do
      sign_in invitee

      expect {
        post attendances_path, params: { attendance: { attended_event_id: event.id } }
      }.to change(Attendance, :count).by(1)

      expect(response).to redirect_to(event_path(event))
      expect(event.attendees).to include(invitee)
    end

    it "marks the invitation as accepted when an invited user registers" do
      sign_in invitee

      expect {
        post attendances_path, params: { attendance: { attended_event_id: event.id } }
      }.to change { event.invitations.find_by(user: invitee).status }.from("pending").to("accepted")
    end

    it "does not let a user who is not invited register, and shows an alert" do
      sign_in stranger

      expect {
        post attendances_path, params: { attendance: { attended_event_id: event.id } }
      }.not_to change(Attendance, :count)

      expect(response).to redirect_to(events_path)
      expect(flash[:alert]).to be_present
    end
  end

  describe "DELETE /attendances/:id" do
    it "lets an attendee cancel their own attendance" do
      attendance = create(:attendance, attendee: invitee, attended_event: event)
      sign_in invitee

      expect { delete attendance_path(attendance) }.to change(Attendance, :count).by(-1)

      expect(response).to redirect_to(event_path(event))
    end

    it "does not let the creator cancel their own attendance, and shows an alert" do
      creator_attendance = event.attendances.find_by(attendee: creator)
      sign_in creator

      expect { delete attendance_path(creator_attendance) }.not_to change(Attendance, :count)

      expect(response).to redirect_to(events_path)
      expect(flash[:alert]).to be_present
    end
  end
end

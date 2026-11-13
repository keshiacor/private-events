require "rails_helper"

RSpec.describe "Invitations", type: :request do
  let(:creator) { create(:user) }
  let(:invitee) { create(:user) }
  let(:stranger) { create(:user) }
  let!(:event) { create(:event, creator: creator) }

  describe "POST /events/:event_id/invitations" do
    it "lets the creator invite a user" do
      sign_in creator

      expect {
        post event_invitations_path(event), params: { user_id: invitee.id }
      }.to change(event.invitations, :count).by(1)

      expect(response).to redirect_to(event_path(event))
      expect(event.invited_users).to include(invitee)
    end

    it "does not let a non-creator invite a user, and shows an alert" do
      sign_in stranger

      expect {
        post event_invitations_path(event), params: { user_id: invitee.id }
      }.not_to change(Invitation, :count)

      expect(response).to redirect_to(events_path)
      expect(flash[:alert]).to be_present
    end
  end

  describe "DELETE /events/:event_id/invitations/:id" do
    let!(:invitation) { create(:invitation, event: event, user: invitee) }

    it "lets the creator remove an invitation" do
      sign_in creator

      expect {
        delete event_invitation_path(event, invitation)
      }.to change(Invitation, :count).by(-1)

      expect(response).to redirect_to(event_path(event))
    end

    it "does not let a non-creator remove an invitation, and shows an alert" do
      sign_in stranger

      expect {
        delete event_invitation_path(event, invitation)
      }.not_to change(Invitation, :count)

      expect(response).to redirect_to(events_path)
      expect(flash[:alert]).to be_present
    end
  end
end

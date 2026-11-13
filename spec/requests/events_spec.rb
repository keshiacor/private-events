require "rails_helper"

RSpec.describe "Events", type: :request do
  let(:creator) { create(:user) }
  let(:invitee) { create(:user) }
  let(:stranger) { create(:user) }
  let!(:event) { create(:event, creator: creator) }

  before { create(:invitation, event: event, user: invitee) }

  describe "GET /events" do
    it "lists every event for any signed-in user, even ones they are not invited to" do
      sign_in stranger

      get events_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(event.name)
    end

    it "redirects a signed-out visitor to the sign-in page" do
      get events_path

      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe "GET /events/:id" do
    it "lets the creator open the event" do
      sign_in creator

      get event_path(event)

      expect(response).to have_http_status(:ok)
    end

    it "lets an invited user open the event" do
      sign_in invitee

      get event_path(event)

      expect(response).to have_http_status(:ok)
    end

    it "redirects a user who is not invited, with an alert" do
      sign_in stranger

      get event_path(event)

      expect(response).to redirect_to(events_path)
      expect(flash[:alert]).to be_present
    end
  end

  describe "GET /events/:id/edit" do
    it "redirects a non-creator, with an alert" do
      sign_in invitee

      get edit_event_path(event)

      expect(response).to redirect_to(events_path)
      expect(flash[:alert]).to be_present
    end
  end

  describe "PATCH /events/:id" do
    it "lets the creator update the event" do
      sign_in creator

      patch event_path(event), params: { event: { name: "New name" } }

      expect(response).to redirect_to(event_path(event))
      expect(event.reload.name).to eq("New name")
    end

    it "re-renders the form when the update is invalid" do
      sign_in creator

      patch event_path(event), params: { event: { name: "" } }

      expect(response).to have_http_status(:unprocessable_content)
      expect(event.reload.name).not_to be_blank
    end

    it "redirects a non-creator with an alert and leaves the event unchanged" do
      sign_in invitee

      expect {
        patch event_path(event), params: { event: { name: "Hacked" } }
      }.not_to change { event.reload.name }

      expect(response).to redirect_to(events_path)
      expect(flash[:alert]).to be_present
    end
  end

  describe "DELETE /events/:id" do
    it "lets the creator delete the event" do
      sign_in creator

      expect { delete event_path(event) }.to change(Event, :count).by(-1)

      expect(response).to redirect_to(events_path)
    end

    it "redirects a non-creator with an alert and does not delete the event" do
      sign_in invitee

      expect { delete event_path(event) }.not_to change(Event, :count)

      expect(response).to redirect_to(events_path)
      expect(flash[:alert]).to be_present
    end
  end
end

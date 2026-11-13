require "rails_helper"

RSpec.describe "Users", type: :request do
  let(:user) { create(:user) }

  describe "GET /users/:id" do
    it "lists the events the user created and the events they were invited to" do
      created_event = create(:event, name: "My Own Party", creator: user)
      invited_event = create(:event, name: "Invited Party")
      create(:invitation, event: invited_event, user: user)
      sign_in user

      get user_path(user)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(created_event.name, invited_event.name)
    end

    it "does not list events the user has no access to" do
      create(:event, name: "Secret Party")
      sign_in user

      get user_path(user)

      expect(response.body).not_to include("Secret Party")
    end

    it "redirects a signed-out visitor to the sign-in page" do
      get user_path(user)

      expect(response).to redirect_to(new_user_session_path)
    end
  end
end

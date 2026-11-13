require "rails_helper"

RSpec.describe Event do
  describe "#accessible_by?" do
    let(:creator) { create(:user) }
    let(:invitee) { create(:user) }
    let(:outsider) { create(:user) }
    let(:event) { create(:event, creator: creator) }

    before { create(:invitation, event: event, user: invitee) }

    it "is true for the creator" do
      expect(event.accessible_by?(creator)).to be true
    end

    it "is true for an invited user" do
      expect(event.accessible_by?(invitee)).to be true
    end

    it "is false for a user who is neither the creator nor invited" do
      expect(event.accessible_by?(outsider)).to be false
    end

    it "is false when there is no user" do
      expect(event.accessible_by?(nil)).to be false
    end
  end

  describe "scopes" do
    let!(:earlier_today) { create(:event, event_date: 1.hour.ago) }
    let!(:later_today) { create(:event, event_date: 1.hour.from_now) }

    it ".past returns only events that have already started" do
      expect(Event.past).to contain_exactly(earlier_today)
    end

    it ".upcoming returns only events that have not started yet" do
      expect(Event.upcoming).to contain_exactly(later_today)
    end
  end
end

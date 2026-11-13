require "rails_helper"

RSpec.describe "factories" do
  it "builds a valid user" do
    expect(build(:user)).to be_valid
  end

  it "builds a valid event" do
    expect(build(:event)).to be_valid
  end

  it "builds a valid invitation" do
    expect(build(:invitation)).to be_valid
  end

  it "creates a valid attendance" do
    expect(create(:attendance)).to be_persisted
  end

  it "gives the event creator exactly one attendance" do
    event = create(:event)

    expect(event.attendances.where(attendee: event.creator).count).to eq(1)
  end
end

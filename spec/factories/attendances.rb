# Creating an event already creates the creator's attendance (after_create callback),
# so only use this factory for non-creator attendees.
FactoryBot.define do
  factory :attendance do
    association :attendee, factory: :user
    association :attended_event, factory: :event
  end
end

FactoryBot.define do
  factory :event do
    name { "Devs Unite" }
    location { "123 Disney Street" }
    event_date { 1.week.from_now }
    association :creator, factory: :user

    trait :upcoming do
      event_date { 1.week.from_now }
    end

    trait :past do
      event_date { 1.week.ago }
    end
  end
end

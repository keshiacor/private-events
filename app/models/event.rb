class Event < ApplicationRecord
  belongs_to :creator, class_name: "User", foreign_key: "creator_id"
  has_many :attendances, foreign_key: "attended_event_id", dependent: :destroy
  has_many :attendees, through: :attendances, source: :attendee
  has_many :invitations, dependent: :destroy
  has_many :invited_users, through: :invitations, source: :user

  scope :past, -> { where("event_date < ?", Date.today && Time.now) }
  scope :upcoming, -> { where("event_date >= ?", Date.today && Time.now) }
end

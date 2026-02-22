class Invitation < ApplicationRecord
  belongs_to :event
  belongs_to :user
  has_one :attendance, through: :event
  validates :status, presence: true
end

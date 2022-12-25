class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :event

  validates :no_of_tickets, :amount_paid, presence: true
end

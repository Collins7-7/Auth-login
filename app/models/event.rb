class Event < ApplicationRecord

    has_many :bookings

    validates :name, presence: true, uniqueness: true
    validates :description, presence: true
end

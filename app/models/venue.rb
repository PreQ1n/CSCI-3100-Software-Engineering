class Venue < ApplicationRecord
    has_many :venue_records

    validates :name, presence: true, uniqueness: true
    validates :venue_id, uniqueness: true, allow_blank: true
end

class Venue < ApplicationRecord
    validates :venue_id, uniqueness: true, allow_blank: true
    has_many :venue_records
end

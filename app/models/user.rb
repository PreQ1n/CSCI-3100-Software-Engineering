class User < ApplicationRecord
    has_secure_password
    has_many :venue_records
    has_many :equipment_records

    validates :email, presence: true, uniqueness: true
end

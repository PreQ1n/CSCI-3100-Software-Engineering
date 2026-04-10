class Equipment < ApplicationRecord
    has_many :equipment_records

    validates :name, presence: true, uniqueness: true
    validates :quantity, presence: true
end

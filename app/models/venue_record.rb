class VenueRecord < ApplicationRecord
  belongs_to :user
  belongs_to :venue

  def venue_name
    venue&.name
  end

  scope :expired, -> { where(is_absence: nil).where("date < ? OR (date = ? AND time < ?)", Date.current, Date.current, 1.hour.ago)}

  def self.update_expired_record(user)
    where(user_id: user.id).expired.update_all(is_absence: true)
  end

end

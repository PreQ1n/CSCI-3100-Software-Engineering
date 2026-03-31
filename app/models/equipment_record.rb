class EquipmentRecord < ApplicationRecord
  belongs_to :user
  belongs_to :equipment

  def equipment_name
    equipment&.name
  end

  def start_time
  return nil unless date && time
  DateTime.new(date.year, date.month, date.day, time.hour, time.min)
end

  scope :expired, -> { where(is_absence: nil).where("date < ? OR (date = ? AND time < ?)", Date.current, Date.current, 1.hour.ago)}

  def self.update_expired_record(user)
    where(user_id: user.id).expired.update_all(is_absence: true)
  end

end

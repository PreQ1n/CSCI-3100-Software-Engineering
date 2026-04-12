class EquipmentRecord < ApplicationRecord
  belongs_to :user
  belongs_to :equipment

  validates :borrow_date, presence: true
  validates :expected_return_date, presence: true
  validate :borrow_date_not_in_past
  validate :expected_return_date_after_borrow_date
  validate :equipment_available_at_booking, if: :validate_equipment_availability?

  def borrow_date_not_in_past
    return if borrow_date.blank?
    errors.add(:borrow_date, "cannot be in the past") if borrow_date < Date.current
  end

  def expected_return_date_after_borrow_date
    return if borrow_date.blank? || expected_return_date.blank?
    if expected_return_date < borrow_date
      errors.add(:expected_return_date, "must be on or after borrow date")
    end
  end

  def equipment_available_at_booking
    if equipment && equipment.quantity <= 0
      errors.add(:base, "This equipment is out of stock")
    end
  end

  def validate_equipment_availability?
    new_record? || will_save_change_to_equipment_id?
  end

  def equipment_name
    equipment&.name
  end

  scope :pending_borrow, -> { where(status: "Pending Borrow") }
  scope :pending_return, -> { where(status: "Borrowed") }
  scope :expired, -> { where(is_absence: nil).where("borrow_date < ?", Date.current) }

  def self.update_expired_record(user)
    where(user_id: user.id).expired.update_all(is_absence: true)
  end
end

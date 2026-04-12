class VenueRecord < ApplicationRecord
  belongs_to :user
  belongs_to :venue

  validates :date, presence: true
  validates :time, presence: true
  validates :time, uniqueness: { scope: [:venue_id, :date],
                                message: "This timeslot was just booked by someone else. Please choose another." }
  validate :date_cannot_be_in_the_past

  def date_cannot_be_in_the_past
    return if date.blank?
    errors.add(:date, "cannot be in the past") if date < Date.current
  end

  def venue_name
    venue&.name
  end

  scope :expired, -> { where(is_absence: nil).where("date < ? OR (date = ? AND time < ?)", Date.current, Date.current, 1.hour.ago)}

  def self.update_expired_record(user)
    where(user_id: user.id).expired.includes(:venue, :user).find_each do |record|
      next unless record.update_columns(is_absence: true)

      BrevoEmail.venue_absence_reminder(record.user, record)
    end
  end

end

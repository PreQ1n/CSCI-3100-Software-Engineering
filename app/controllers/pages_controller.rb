require 'ostruct'

class PagesController < ApplicationController
  before_action :user_authentication, only: [:confirmation, :calendar, :history]
  before_action :update_expired_records, only: [:confirmation]

  def hello
  end

  def confirmation
    @user = current_user
    @venue_records = VenueRecord.where(user_id: current_user.id, date: Date.current).includes(:venue)
    # Show all unconfirmed equipment records, not just today's
    @equipment_records = EquipmentRecord.where(user_id: current_user.id, is_absence: nil).includes(:equipment)
  end

  def calendar
    @user = current_user

    @date = params[:date] ? Date.parse(params[:date]) : Date.current
    
    venue_bookings = VenueRecord.where(user_id: current_user.id).includes(:venue)
    
    equipment_bookings = EquipmentRecord.where(user_id: current_user.id).includes(:equipment)
    
    #simple_calendar gem require a start_time variable, so make a new struct to pass 
    #We can identify the record is equipment or venue by checking its nullity.
    @bookings_date = (equipment_bookings + venue_bookings).map do |record|

      # Handle different date/time fields for equipment vs venue records
      if record.is_a?(EquipmentRecord)

        # Equipment records use borrow_date, use default time for calendar display
        booking_date = record.borrow_date

        # Equipment bookings are date-based, so use default 9 AM time
        start_time = DateTime.new(booking_date.year, booking_date.month, booking_date.day, 9, 0, 0)
        display_time = Time.new(2026, 1, 1, 9, 0, 0) # 9 AM default display time

      else
        # Venue records use date and time
        start_time = DateTime.new(record.date.year, record.date.month, record.date.day, record.time.hour, record.time.min, 0)
        display_time = record.time
      end

      OpenStruct.new(
        start_time: start_time,
        time: display_time,
        equipment: record.try(:equipment_name),
        venue: record.try(:venue_name)
      )
    end
  end

  def history
    @user = current_user  # Assuming current_user is defined in ApplicationController
    @record_type = params[:type] || 'venue'  # Default to venue; toggle via buttons
    
    if @record_type == 'equipment'
      @records = @user.equipment_records.includes(:equipment).order(borrow_date: :desc, expected_return_date: :desc)
    else
      @records = @user.venue_records.includes(:venue).order(date: :desc, time: :desc)
    end
  end

  def analytics_dashboard
    unless current_user&.admin?
      redirect_to root_path, alert: "Access denied."
      return
    end

    @start_date = params[:start_date].present? ? Date.parse(params[:start_date]) : 1.week.ago.to_date
    @end_date = params[:end_date].present? ? Date.parse(params[:end_date]) : Date.today

    # Debug: Check all equipment records
    all_equipment = EquipmentRecord.all
    Rails.logger.info "DEBUG: Total equipment records in DB: #{all_equipment.count}"
    if all_equipment.any?
      Rails.logger.info "DEBUG: All equipment borrow_dates: #{all_equipment.pluck(:borrow_date)}"
      Rails.logger.info "DEBUG: All equipment is_absence values: #{all_equipment.pluck(:is_absence)}"
    end
    
    Rails.logger.info "DEBUG: Date range: #{@start_date} to #{@end_date}"
    Rails.logger.info "DEBUG: Current user ID: #{current_user&.id}"

    venue_records = VenueRecord.where(date: @start_date..@end_date).includes(:user, :venue)
    equipment_records = EquipmentRecord.where(borrow_date: @start_date..@end_date).includes(:user, :equipment)
    
    Rails.logger.info "DEBUG: Equipment records in date range: #{equipment_records.count}"

    total_records = venue_records.count + equipment_records.count
    absence_count = venue_records.where(is_absence: true).count + equipment_records.where(is_absence: true).count
    late_return_count = equipment_records.where(is_returnLate: true).count

    @absence_rate = total_records > 0 ? (absence_count.to_f / total_records * 100).round(1) : 0  
    @late_return_rate = equipment_records.count > 0 ? (late_return_count.to_f / equipment_records.count * 100).round(1) : 0  
    @overall_usage_rate = calculate_usage_rate(venue_records, equipment_records)
    
    @top_venues = venue_records.joins(:venue).group('venues.name').count.sort_by { |k, v| -v }.to_h
    @top_equipment = equipment_records.joins(:equipment).group('equipment.name').count.sort_by { |k, v| -v }.to_h

    @faculty_distribution = combined_user_distribution(venue_records, equipment_records, 'users.faculty')
    @college_distribution = combined_user_distribution(venue_records, equipment_records, 'users.college')
    @major_distribution = combined_user_distribution(venue_records, equipment_records, 'users.major').first(5).to_h
    @user_booking_frequency = calculate_user_booking_frequency(venue_records, equipment_records)
    @venue_utilization = calculate_venue_utilization(venue_records)
    @avg_bookings_per_day = calculate_avg_bookings_per_day(venue_records, equipment_records)
    
  end

  def confirmation
    @user = current_user
    @venue_records = VenueRecord.where(user_id: current_user.id, date: Date.current).includes(:venue)
    # Separate pending borrows and pending returns
    @equipment_pending_borrow = EquipmentRecord.where(user_id: current_user.id).pending_borrow.includes(:equipment)
    @equipment_pending_return = EquipmentRecord.where(user_id: current_user.id).pending_return.includes(:equipment)
  end

  private

  def update_expired_records
    VenueRecord.update_expired_record(current_user)
    EquipmentRecord.update_expired_record(current_user)
  end
  
  def calculate_usage_rate(venue_records, equipment_records)
    booked_slots = booked_booking_slots(venue_records, equipment_records)
    total_slots = total_possible_booking_slots(@start_date, @end_date)

    total_slots.zero? ? 0 : ((booked_slots.to_f / total_slots) * 100).round(1)
  end

  def total_possible_booking_slots(start_date, end_date)
    days = (end_date - start_date).to_i + 1
    hours_per_day = 12  # 9am–9pm

    venue_capacity = Venue.count * hours_per_day
    equipment_capacity = Equipment.sum(:quantity) * hours_per_day

    (venue_capacity + equipment_capacity) * days
  end

  def booked_booking_slots(venue_records, equipment_records)
    venue_records.where(is_absence: [false, nil]).count +
      equipment_records.where(is_absence: [false, nil]).count
  end
  
  def calculate_user_booking_frequency(venue_records, equipment_records)
    user_bookings = {}
    
    # Count bookings per user
    (venue_records + equipment_records).each do |record|
      user_id = record.user_id
      user_bookings[user_id] ||= 0
      user_bookings[user_id] += 1 unless record.is_absence
    end

    repeat_users = user_bookings.values.count { |count| count >= 2 }
    one_time_users = user_bookings.values.count { |count| count == 1 }

    {
      repeat_users_count: repeat_users,
      one_time_users_count: one_time_users,
      total_users: user_bookings.count,
      details: user_bookings.sort_by { |_user_id, count| -count }.to_h
    }
  end

  def calculate_venue_utilization(venue_records)
    venue_bookings = venue_records.where(is_absence: [false, nil]).group_by(&:venue_id)
    
    venues_with_util = Venue.all.map do |venue|
      bookings = venue_bookings[venue.id]&.count || 0
      slots_per_day = 12
      days = (@end_date - @start_date).to_i + 1
      total_slots = slots_per_day * days
      utilization = total_slots.zero? ? 0 : ((bookings.to_f / total_slots) * 100).round(1)
      
      {
        name: venue.name,
        bookings: bookings,
        utilization_rate: utilization
      }
    end
    
    venues_with_util.sort_by { |v| -v[:utilization_rate] }
  end

  def calculate_avg_bookings_per_day(venue_records, equipment_records)
    venue_count = venue_records.where(is_absence: [false, nil]).count
    equipment_count = equipment_records.where(is_absence: [false, nil]).count
    total_bookings = venue_count + equipment_count
    days = (@end_date - @start_date).to_i + 1
    
    # Debug logging
    Rails.logger.info "DEBUG: venue_count = #{venue_count}, equipment_count = #{equipment_count}, total_bookings = #{total_bookings}, days = #{days}"
    Rails.logger.info "DEBUG: start_date = #{@start_date}, end_date = #{@end_date}"
    Rails.logger.info "DEBUG: equipment_records count = #{equipment_records.count}"
Rails.logger.info "DEBUG: equipment_records with is_absence not true = #{equipment_records.where(is_absence: [false, nil]).count}"
    (total_bookings.to_f / days).round(1)
  end
end

  def combined_user_distribution(venue_records, equipment_records, group_field)
    venue_records.joins(:user)
                 .group(group_field)
                 .count
                 .merge(
                   equipment_records.joins(:user)
                                    .group(group_field)
                                    .count
                 ) { |_key, venue_count, equipment_count| venue_count + equipment_count }
                 .sort_by { |_key, count| -count }
                 .to_h
  end

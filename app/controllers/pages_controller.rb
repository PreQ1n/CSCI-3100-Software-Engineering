require 'ostruct'

class PagesController < ApplicationController
  before_action :user_authentication, only: [:confirmation, :calendar, :history]
  before_action :update_expired_records, only: [:confirmation]

  def hello
  end

  def confirmation
    @user = current_user
    @venue_records = VenueRecord.where(user_id: current_user.id, date: Date.current).includes(:venue)
    @equipment_records = EquipmentRecord.where(user_id: current_user.id, date: Date.current).includes(:equipment)
  end

  def calendar
    @user = current_user

    @date = params[:date] ? Date.parse(params[:date]) : Date.current
    
    venue_bookings = VenueRecord.where(user_id: current_user.id).includes(:venue)
    
    equipment_bookings = EquipmentRecord.where(user_id: current_user.id).includes(:equipment)
    
    #simple_calendar gem require a start_time variable, so make a new struct to pass 
    #We can idenify the record is equipment or venue by checking its nullity.
    @bookings_date = (equipment_bookings + venue_bookings).map do |record|
      start_time = DateTime.new(record.date.year, record.date.month, record.date.day, record.time.hour, record.time.min, 0)

      OpenStruct.new(
        start_time: start_time,
        time: record.time,
        equipment: record.try(:equipment_name),
        venue: record.try(:venue_name)
      )

    end
  end

  def history
  end

  private

  def update_expired_records
    VenueRecord.update_expired_record(current_user)
    EquipmentRecord.update_expired_record(current_user)
  end
  
end

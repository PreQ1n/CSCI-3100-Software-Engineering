class AnalyticsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin!

  def dashboard
    @start_date = Date.new(2026, 3, 1)
    @end_date = Date.new(2026, 3, 5)

    # Calculate all analytics metrics
    calculate_usage_rate
    calculate_absence_rate
    calculate_late_return_rate
    calculate_top_venues
    calculate_top_equipment
    calculate_faculty_distribution
    calculate_college_distribution
    calculate_major_distribution
  end

  private

  def authenticate_user!
    redirect_to login_path unless session[:user_id]
  end

  def authorize_admin!
    # Add your admin check logic here
    # For now, assuming logged-in users are admins
  end

  def calculate_usage_rate
    total_records = VenueRecord.where(date: @start_date..@end_date).count +
                    EquipmentRecord.where(date: @start_date..@end_date).count
    total_absence = VenueRecord.where(date: @start_date..@end_date, is_absence: true).count +
                    EquipmentRecord.where(date: @start_date..@end_date, is_absence: true).count
    
    usage_count = total_records - total_absence
    total_possible = User.count * 5 * 2 # 12 users * 5 days * 2 record types (venue + equipment)
    
    @overall_usage_rate = ((usage_count.to_f / total_possible) * 100).round(1)
  end

  def calculate_absence_rate
    total_records = VenueRecord.where(date: @start_date..@end_date).count +
                    EquipmentRecord.where(date: @start_date..@end_date).count
    total_absence = VenueRecord.where(date: @start_date..@end_date, is_absence: true).count +
                    EquipmentRecord.where(date: @start_date..@end_date, is_absence: true).count
    
    @absence_rate = ((total_absence.to_f / total_records) * 100).round(1)
  end

  def calculate_late_return_rate
    total_equipment_records = EquipmentRecord.where(date: @start_date..@end_date).count
    late_returns = EquipmentRecord.where(date: @start_date..@end_date, is_returnLate: true).count
    
    @late_return_rate = ((late_returns.to_f / total_equipment_records) * 100).round(1)
  end

  def calculate_top_venues
    @top_venues = VenueRecord.where(date: @start_date..@end_date)
                              .group_by(&:venue_id)
                              .map { |venue_id, records| [Venue.find(venue_id).name, records.count] }
                              .sort_by { |_name, count| -count }
                              .first(5)
  end

  def calculate_top_equipment
    @top_equipment = EquipmentRecord.where(date: @start_date..@end_date)
                                     .group_by(&:equipment_id)
                                     .map { |equipment_id, records| [Equipment.find(equipment_id).name, records.count] }
                                     .sort_by { |_name, count| -count }
                                     .first(5)
  end

  def calculate_faculty_distribution
    @faculty_distribution = VenueRecord.joins(:user)
                                        .where(date: @start_date..@end_date)
                                        .group('users.faculty')
                                        .count
                                        .merge(
                                          EquipmentRecord.joins(:user)
                                                         .where(date: @start_date..@end_date)
                                                         .group('users.faculty')
                                                         .count
                                        ) { |_k, v1, v2| v1 + v2 }
                                        .sort_by { |_faculty, count| -count }
  end

  def calculate_college_distribution
    @college_distribution = VenueRecord.joins(:user)
                                        .where(date: @start_date..@end_date)
                                        .group('users.college')
                                        .count
                                        .merge(
                                          EquipmentRecord.joins(:user)
                                                         .where(date: @start_date..@end_date)
                                                         .group('users.college')
                                                         .count
                                        ) { |_k, v1, v2| v1 + v2 }
                                        .sort_by { |_college, count| -count }
  end

  def calculate_major_distribution
    @major_distribution = VenueRecord.joins(:user)
                                      .where(date: @start_date..@end_date)
                                      .group('users.major')
                                      .count
                                      .merge(
                                        EquipmentRecord.joins(:user)
                                                       .where(date: @start_date..@end_date)
                                                       .group('users.major')
                                                       .count
                                      ) { |_k, v1, v2| v1 + v2 }
                                      .sort_by { |_major, count| -count }
                                      .first(5)
  end
end
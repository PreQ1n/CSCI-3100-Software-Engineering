class ConfirmationController < ApplicationController
  before_action :user_authentication

  def confirm
    if params[:type] == "venue"
      record = VenueRecord.find_by(id: params[:id])
      record.update(is_absence: false)
      flash[:notice] = "Venue attendance confirmed"
    elsif params[:type] == "equipment"
      record = EquipmentRecord.find_by(id: params[:id])
      
      if params[:action_type] == "borrow"
        # User is picking up the equipment
        if record.update(status: "Borrowed", confirmed_borrow_at: Time.current)
          flash[:notice] = "Equipment pickup confirmed. Remember to return by #{record.expected_return_date.strftime('%Y-%m-%d')}"
        else
          flash[:alert] = record.errors.full_messages.join(", ")
        end
      elsif params[:action_type] == "return"
        # User is returning the equipment
        is_late = Time.current.to_date > record.expected_return_date
        record.update(
          status: "Returned",
          confirmed_return_at: Time.current,
          is_returnLate: is_late
        )
        # Increment quantity when returned
        record.equipment.increment!(:quantity)
        
        if is_late
          flash[:notice] = "Equipment return confirmed (Late return)"
        else
          flash[:notice] = "Equipment return confirmed"
        end
      end
    else
      flash[:alert] = "Error occurred. Please try again."
    end

    redirect_to confirmation_path, allow_other_host: false
  end
end
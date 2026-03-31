class ConfirmationController < ApplicationController

    before_action :user_authentication

    def confirm
        if params[:type] == "venue"
            record = VenueRecord.find_by(id: params[:id])
            record.update(is_absence: false)
            flash[:notice] = "Attendance confirmed"
        elsif params[:type] == "equipment"
            record = EquipmentRecord.find_by(id: params[:id])
            record.update(is_absence: false)
            flash[:notice] = "Attendance confirmed"
        else
            flash[:alert] = "Error occur. Please change again. "
        end

        redirect_to confirmation_path
    end

end
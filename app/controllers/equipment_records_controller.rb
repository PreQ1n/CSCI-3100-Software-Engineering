class EquipmentRecordsController < ApplicationController
  before_action :set_equipment_record, only: %i[ show edit update destroy ]

  # GET /equipment_records or /equipment_records.json
  def index
    @equipment_records = EquipmentRecord.all
  end

  # GET /equipment_records/1 or /equipment_records/1.json
  def show
  end

  # GET /equipment_records/new
  def new
    if !logged_in?
      user_authentication
      return
    end
    @equipment_record = EquipmentRecord.new(equipment: Equipment.find_by(id: params[:equipment_id]))
  end

  # GET /equipment_records/1/edit
  def edit
  end

  # POST /equipment_records or /equipment_records.json
  def create
    @equipment_record = EquipmentRecord.new(equipment_record_params)
    @equipment_record.user_id = current_user.id
    @equipment_record.equipment = Equipment.find_by(id: params[:equipment_record][:equipment_id])

    respond_to do |format|
      if @equipment_record.save
        format.html { redirect_to root_path, notice: "Equipment was successfully booked." }
        format.json { render :show, status: :created, location: @equipment_record }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @equipment_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /equipment_records/1 or /equipment_records/1.json
  def update
    respond_to do |format|
      if @equipment_record.update(equipment_record_params)
        format.html { redirect_to @equipment_record, notice: "Equipment record was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @equipment_record }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @equipment_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /equipment_records/1 or /equipment_records/1.json
  def destroy
    @equipment_record.destroy!

    respond_to do |format|
      format.html { redirect_to equipment_records_path, notice: "Equipment record was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_equipment_record
      @equipment_record = EquipmentRecord.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def equipment_record_params
      params.fetch(:equipment_record, {})
      params.require(:equipment_record).permit(:user_id, :equipment_id, :date, :time)
    end
end

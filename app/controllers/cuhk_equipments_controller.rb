class CuhkEquipmentsController < ApplicationController
  before_action :set_cuhk_equipment, only: %i[ show edit update destroy ]

  # GET /cuhk_equipments or /cuhk_equipments.json
  def index
    if params[:query].present?
      @cuhk_equipments = CuhkEquipment.where("name LIKE ?", "%#{params[:query]}%")
                                       .order(:name)
    else
      @cuhk_equipments = CuhkEquipment.all.order(:name)
    end
  
    if turbo_frame_request?
      # This renders JUST the table part for the live search
      render partial: "cuhk_equipments", locals: { cuhk_equipments: @cuhk_equipments }
    else
      # This renders the full page on initial load
      render :index
    end  
  end

  # GET /cuhk_equipments/1 or /cuhk_equipments/1.json
  def show
  end

  # GET /cuhk_equipments/new
  def new
    @cuhk_equipment = CuhkEquipment.new
  end

  # GET /cuhk_equipments/1/edit
  def edit
  end

  # POST /cuhk_equipments or /cuhk_equipments.json
  def create
    @cuhk_equipment = CuhkEquipment.new(cuhk_equipment_params)

    respond_to do |format|
      if @cuhk_equipment.save
        format.html { redirect_to @cuhk_equipment, notice: "Cuhk equipment was successfully created." }
        format.json { render :show, status: :created, location: @cuhk_equipment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @cuhk_equipment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cuhk_equipments/1 or /cuhk_equipments/1.json
  def update
    respond_to do |format|
      if @cuhk_equipment.update(cuhk_equipment_params)
        format.html { redirect_to @cuhk_equipment, notice: "Cuhk equipment was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @cuhk_equipment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @cuhk_equipment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cuhk_equipments/1 or /cuhk_equipments/1.json
  def destroy
    @cuhk_equipment.destroy!

    respond_to do |format|
      format.html { redirect_to cuhk_equipments_path, notice: "Cuhk equipment was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cuhk_equipment
      @cuhk_equipment = CuhkEquipment.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def cuhk_equipment_params
      params.expect(cuhk_equipment: [ :name, :description ])
    end
end

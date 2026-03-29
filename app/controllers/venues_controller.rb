class VenuesController < ApplicationController
  before_action :set_venue, only: %i[ show edit update destroy ]

  # GET /venues or /venues.json
  def index
    # 1. 基礎查詢
    @venues = Venue.all
  
    # 2. 搜尋邏輯
    if params[:search].present?
      # 安全白名單：確保欄位名稱是我們允許的
      allowed_columns = ["name", "building", "description"]
      column = allowed_columns.include?(params[:search_column]) ? params[:search_column] : "name"
      
      @venues = @venues.where("#{column} LIKE ?", "%#{params[:search]}%")
    end
  
    # 3. 回應處理
    if turbo_frame_request?
      # 注意：這裡的 locals 名稱要跟 Partial 內使用的變數名一致
      render partial: "venues_table", locals: { venues: @venues }
    else
      render :index
    end
  end

  # GET /venues/1 or /venues/1.json
  def show
  end

  # GET /venues/new
  def new
    @venue = Venue.new
  end

  # GET /venues/1/edit
  def edit
  end

  # POST /venues or /venues.json
  def create
    @venue = Venue.new(venue_params)

    respond_to do |format|
      if @venue.save
        format.html { redirect_to @venue, notice: "Venue was successfully created." }
        format.json { render :show, status: :created, location: @venue }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @venue.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /venues/1 or /venues/1.json
  def update
    respond_to do |format|
      if @venue.update(venue_params)
        format.html { redirect_to @venue, notice: "Venue was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @venue }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @venue.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /venues/1 or /venues/1.json
  def destroy
    @venue.destroy!

    respond_to do |format|
      format.html { redirect_to venues_path, notice: "Venue was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_venue
      @venue = Venue.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def venue_params
      params.require(:venue).permit(:name, :venue_id, :building, :description)
    end
end

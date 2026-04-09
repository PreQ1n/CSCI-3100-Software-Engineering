class VenueRecordsController < ApplicationController
  before_action :set_venue_record, only: %i[ show edit update destroy ]

  # GET /venue_records or /venue_records.json
  def index
    @venue_records = VenueRecord.all
  end

  # GET /venue_records/1 or /venue_records/1.json
  def show
  end

  # GET /venue_records/new
  def new
    if !logged_in?
      user_authentication
      return
    end
    @venue_record = VenueRecord.new(venue: Venue.find_by!(venue_id: params[:venue_id]))
  end

  # GET /venue_records/1/edit
  def edit
  end

  # POST /venue_records or /venue_records.json
  def create
    @venue_record = VenueRecord.new(venue_record_params)
    @venue_record.venue = Venue.find_by(venue_id: params[:venue_record][:venue_id])
    @venue_record.user_id = current_user.id

    respond_to do |format|
      if @venue_record.save
        format.html { redirect_to root_path, notice: "Venue record was successfully created." }
        format.json { render :show, status: :created, location: @venue_record }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @venue_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /venue_records/1 or /venue_records/1.json
  def update
    respond_to do |format|
      if @venue_record.update(venue_record_params)
        format.html { redirect_to @venue_record, notice: "Venue record was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @venue_record }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @venue_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /venue_records/1 or /venue_records/1.json
  def destroy
    @venue_record.destroy!

    respond_to do |format|
      format.html { redirect_to venue_records_path, notice: "Venue record was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_venue_record
      @venue_record = VenueRecord.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def venue_record_params
      params.fetch(:venue_record, {})
      params.require(:venue_record).permit(:user_id, :venue_id, :date, :time)
    end
end

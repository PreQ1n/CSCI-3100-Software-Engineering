class VenueRecordsController < ApplicationController
  before_action :set_venue_record, only: %i[ edit update destroy ]

  # GET /venue_records or /venue_records.json
  def index
    @venue_records = current_user.venue_records.includes(:venue)
  end

  # GET /venue_records/new
  def new
    if !logged_in?
      user_authentication
      return
    end
    @venue_record = VenueRecord.new(venue: Venue.find_by(venue_id: params[:venue_id]))
  end

  # GET /venue_records/1/edit
  def edit
  end

  # POST /venue_records or /venue_records.json
  def create
    @venue_record = VenueRecord.new(venue_record_params)
    @venue_record.user_id = current_user.id
    @venue_record.venue = Venue.find_by(venue_id: params[:venue_record][:venue_id])

    begin
      if @venue_record.save
        BrevoEmail.venue_booking_confirmed(current_user, @venue_record)
        redirect_to venue_records_path, notice: "Booking confirmed!"
      else
        flash.now[:alert] = @venue_record.errors.full_messages.to_sentence
        render :new, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordNotUnique
      @venue_record.errors.add(:time, "This slot was just taken. Please pick another time.")
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /venue_records/1 or /venue_records/1.json
  def update
    if @venue_record.update(venue_record_params)
      redirect_to venue_records_path, notice: "Venue record was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
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

  def booked_slots
    booked = VenueRecord
      .where(venue_id: params[:venue_id], date: params[:date])
      .pluck(:time)
      .map { |t| t.strftime("%H:%M") }
    render json: booked
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_venue_record
      @venue_record = VenueRecord.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def venue_record_params
      params.fetch(:venue_record, {})
      params.require(:venue_record).permit(:user_id, :venue_id, :date, :time)
    end
end

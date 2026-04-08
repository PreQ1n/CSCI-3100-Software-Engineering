require "rails_helper"

RSpec.describe PagesController, type: :controller do

    let(:user) {create(:user)}

    def sign_in(user)
        session[:user_id] = user.id
    end

    describe "user_authentication" do
        context "when user is not logged in" do
            it "redirects confirmation to login" do
                get :confirmation
                expect(response).to redirect_to(login_path)
            end

            it "redirects calendar to login" do
                get :calendar
                expect(response).to redirect_to(login_path)
            end

            it "redirects history to login" do
                get :history
                expect(response).to redirect_to(login_path)
            end
        end

        context "when user is logged in" do
            before {sign_in user}
            
            it "allow confirmation" do
                get :confirmation
                expect(response).to have_http_status(:success)
            end

            it "allow calendar" do
                get :calendar
                expect(response).to have_http_status(:success)
            end

            it "allow history" do
                get :history
                expect(response).to have_http_status(:success)
            end
        end
    end

    describe "confirmation" do
        before { sign_in user}

        it "assign @user" do
            get :confirmation
            expect(assigns(:user)).to eq(user)
        end

        it "assign @venue_records with today record" do
            today_record = create(:venue_record, user: user, date: Date.current)
            yesterday_record = create(:venue_record, user: user, date: Date.yesterday)

            get :confirmation

            expect(assigns(:venue_records)).to include(today_record)
            expect(assigns(:venue_records)).not_to include(yesterday_record)
        end

        it "assign @equipment_records with today record" do
            today_record = create(:equipment_record, user: user, date: Date.current)
            yesterday_record = create(:equipment_record, user: user, date: Date.yesterday)

            get :confirmation

            expect(assigns(:equipment_records)).to include(today_record)
            expect(assigns(:equipment_records)).not_to include(yesterday_record)
        end
    end

    describe "calendar" do
        before { sign_in user}

        context "date handling" do
            it "use Date.current when no param" do
                get :calendar
                expect(assigns(:date)).to eq(Date.current)
            end

            it "Date parse when has param" do
                get :calendar, params: {date: "2026-04-01" }
                expect(assigns(:date)).to eq(Date.new(2026, 4, 1))
            end

        end

        context "range of date" do 
            it "beginning_of_month" do
                get :calendar, params: {date: "2026-04-01" }
                expect(assigns(:date).beginning_of_month).to eq(Date.new(2026, 4, 1))
            end

            it "end_of_month" do
                get :calendar, params: {date: "2026-04-01" }
                expect(assigns(:date).end_of_month).to eq(Date.new(2026, 4, 30))
            end
        end

        context "booking records" do
            let(:start_date) { Date.current.beginning_of_month }
            let(:end_date) { Date.current.end_of_month }

            it "VenueRecord query within the range" do
                expect(VenueRecord).to receive(:where).with(date: start_date..end_date).and_call_original
                get :calendar
            end

            it "EquipmentRecord query within the range" do
                expect(EquipmentRecord).to receive(:where).with(date: start_date..end_date).and_call_original
                get :calendar
            end
        end

        context "bookings_date construct" do
            let!(:venue_record) do
                create(:venue_record, 
                user: user, 
                date: Date.current, 
                time: Time.zone.parse("14:30"))
            end
            let!(:equipment_record) do
                create(:equipment_record, 
                user: user, 
                date: Date.current, 
                time: Time.zone.parse("10:00"))
            end

            it "combines venue and equipment records" do
                get :calendar
                expect(assigns(:bookings_date).size).to eq(2)
            end

            it "creates OpenStruct for each record" do
                get :calendar
                expect(assigns(:bookings_date).first).to be_a(OpenStruct)
            end

            it "assigns equipment name when present" do
                get :calendar
                booking = assigns(:bookings_date).find { |b| b.equipment.present? }
                expect(booking.equipment).to eq(equipment_record.equipment.name)
            end

            it "assigns venue name when present" do
                get :calendar
                booking = assigns(:bookings_date).find { |b| b.venue.present? }
                expect(booking.venue).to eq(venue_record.venue.name)
            end

        end
    end

    describe "#update_expired_records" do

        before { sign_in user }

        it "calls VenueRecord.update_expired_record with current_user" do
            expect(VenueRecord).to receive(:update_expired_record).with(user)
            get :confirmation
        end

        it "calls EquipmentRecord.update_expired_record with current_user" do
            expect(EquipmentRecord).to receive(:update_expired_record).with(user)
            get :confirmation
        end
    end

end
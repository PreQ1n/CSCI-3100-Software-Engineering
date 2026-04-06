require 'rails_helper'

RSpec.describe VenueRecord, type: :model do

    let(:user) { create(:user) }

    describe "expired record scope" do
        let!(:past_date_record) { create(:venue_record, user: user, date: Date.yesterday, time: Time.current, is_absence: nil) }
        let!(:past_time_record) { create(:venue_record, user: user, date: Date.current, time: 2.hours.ago, is_absence: nil) }
        let!(:future_record) { create(:venue_record, user: user, date: Date.tomorrow, time: Time.current, is_absence: nil) }
        let!(:confirmed_record) { create(:venue_record, user: user, date: Date.yesterday, is_absence: false) }

        it "include date < Date.current" do
            expect(VenueRecord.expired).to include(past_date_record)
        end

        it "include date = Date.current and time < 1 hour ago" do
            expect(VenueRecord.expired).to include(past_time_record)
        end

        it "not include date > Date.current" do
            expect(VenueRecord.expired).not_to include(future_record)
        end

        it "not include confirmed_record" do
            expect(VenueRecord.expired).not_to include(confirmed_record)
        end

    end

    describe "update expired record" do
        let(:other_user) { create(:user) }
        let!(:past_date_record_user) { create(:venue_record, user: user, date: Date.yesterday, time: Time.current, is_absence: nil) }
        let!(:past_date_record_other) { create(:venue_record, user: other_user, date: Date.yesterday, time: Time.current, is_absence: nil) }
        let!(:not_expired_user) {create(:venue_record, user: user, date: Date.tomorrow, is_absence: nil)}


        it "update expired record for given user" do
            VenueRecord.update_expired_record(user)

            expect(past_date_record_user.reload.is_absence).to eq(true)
            expect(past_date_record_other.reload.is_absence).to be_nil
            expect(not_expired_user.reload.is_absence).to be_nil
        end

    end

end
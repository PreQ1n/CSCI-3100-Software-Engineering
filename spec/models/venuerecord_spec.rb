require 'rails_helper'

RSpec.describe VenueRecord, type: :model do

    let(:user) { create(:user) }

    describe "update expired record" do
        let(:other_user) { create(:user) }
        let!(:past_date_record_user) { create(:venue_record, user: user, date: Date.current, time: Time.current - 2.hours, is_absence: nil) }
        let!(:not_expired_user) {create(:venue_record, user: user, date: Date.tomorrow, is_absence: nil)}


        it "update expired record for given user" do
            VenueRecord.update_expired_record(user)

            expect(past_date_record_user.reload.is_absence).to eq(true)
            expect(not_expired_user.reload.is_absence).to be_nil
        end

    end

end
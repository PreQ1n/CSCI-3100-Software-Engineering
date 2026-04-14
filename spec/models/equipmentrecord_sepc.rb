require 'rails_helper'

RSpec.describe EquipmentRecord, type: :model do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:equipment) { create(:equipment, quantity: 5) }

  describe ".update_expired_record" do
    context "when there are expired records" do
      let!(:expired_record_user) do
        record = EquipmentRecord.new(
          user: user,
          equipment: equipment,
          borrow_date: Date.yesterday,
          expected_return_date: Date.tomorrow,
          is_absence: nil,
          status: "Pending Borrow"
        )
        record.save(validate: false)
        record
      end

      let!(:expired_record_other) do
        record = EquipmentRecord.new(
          user: other_user,
          equipment: equipment,
          borrow_date: Date.yesterday,
          expected_return_date: Date.tomorrow,
          is_absence: nil,
          status: "Pending Borrow"
        )
        record.save(validate: false)
        record
      end

      let!(:future_record) do
        create(:equipment_record,
          user: user,
          equipment: equipment,
          borrow_date: Date.tomorrow,
          expected_return_date: Date.tomorrow + 3.days,
          is_absence: nil,
          status: "Pending Borrow"
        )
      end

      let!(:confirmed_record) do
        record = EquipmentRecord.new(
          user: user,
          equipment: equipment,
          borrow_date: Date.yesterday,
          expected_return_date: Date.tomorrow,
          is_absence: false,
          status: "Borrowed"
        )
        record.save(validate: false)
        record
      end

      it "updates expired records for the given user only" do
        EquipmentRecord.update_expired_record(user)

        expect(expired_record_user.reload.is_absence).to eq(true)
        
        expect(expired_record_other.reload.is_absence).to be_nil

        expect(future_record.reload.is_absence).to be_nil
        
        expect(confirmed_record.reload.is_absence).to eq(false)
      end

      it "only updates records with is_absence: nil" do
        EquipmentRecord.update_expired_record(user)
        
        updated_records = EquipmentRecord.where(user: user, is_absence: true)
        expect(updated_records.count).to eq(1)
        expect(updated_records).to include(expired_record_user)
      end

      it "does not update records that are not expired" do
        EquipmentRecord.update_expired_record(user)
        
        expect(future_record.reload.is_absence).to be_nil
        expect(future_record.borrow_date).to be > Date.current
      end
    end

    context "when there are no expired records" do
      let!(:future_record) do
        create(:equipment_record,
          user: user,
          equipment: equipment,
          borrow_date: Date.tomorrow,
          expected_return_date: Date.tomorrow + 3.days,
          is_absence: nil
        )
      end

      it "does not update any records" do
        expect {
          EquipmentRecord.update_expired_record(user)
        }.not_to change { future_record.reload.is_absence }
        
        expect(future_record.reload.is_absence).to be_nil
      end
    end

    context "when user has no records" do
      let(:new_user) { create(:user) }

      it "does nothing and does not raise error" do
        expect {
          EquipmentRecord.update_expired_record(new_user)
        }.not_to raise_error
      end
    end

    context "email sending" do
      let!(:expired_record) do
        record = EquipmentRecord.new(
          user: user,
          equipment: equipment,
          borrow_date: Date.yesterday,
          expected_return_date: Date.tomorrow,
          is_absence: nil,
          status: "Pending Borrow"
        )
        record.save(validate: false)
        record
      end

      it "sends an email for each expired record" do
        expect(BrevoEmail).to receive(:equipment_absence_reminder).with(user, expired_record)
        
        EquipmentRecord.update_expired_record(user)
      end

      it "does not send email if record update fails" do
        allow_any_instance_of(EquipmentRecord).to receive(:update_columns).and_return(false)
        
        expect(BrevoEmail).not_to receive(:equipment_absence_reminder)
        
        EquipmentRecord.update_expired_record(user)
      end
    end
  end

  describe ".expired scope" do
    let!(:expired_record) do
      record = EquipmentRecord.new(
        user: user,
        equipment: equipment,
        borrow_date: Date.yesterday,
        expected_return_date: Date.tomorrow,
        is_absence: nil
      )
      record.save(validate: false)
      record
    end
    
    let!(:future_record) do
      create(:equipment_record,
        user: user,
        equipment: equipment,
        borrow_date: Date.tomorrow,
        expected_return_date: Date.tomorrow + 3.days,
        is_absence: nil
      )
    end
    
    let!(:confirmed_expired_record) do
      record = EquipmentRecord.new(
        user: user,
        equipment: equipment,
        borrow_date: Date.yesterday,
        expected_return_date: Date.tomorrow,
        is_absence: false
      )
      record.save(validate: false)
      record
    end

    it "returns only expired and unconfirmed records" do
      expect(EquipmentRecord.expired).to include(expired_record)
      expect(EquipmentRecord.expired).not_to include(future_record)
      expect(EquipmentRecord.expired).not_to include(confirmed_expired_record)
    end
  end
end
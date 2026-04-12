class UpdateEquipmentRecordsForLending < ActiveRecord::Migration[8.1]
  def change
    add_column :equipment_records, :borrow_date, :date
    add_column :equipment_records, :expected_return_date, :date
    add_column :equipment_records, :status, :string, default: "Pending Borrow"
    add_column :equipment_records, :confirmed_borrow_at, :datetime
    add_column :equipment_records, :confirmed_return_at, :datetime
  end
end
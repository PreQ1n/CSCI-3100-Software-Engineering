class AddIsReturnLateToEquipmentRecords < ActiveRecord::Migration[8.1]
  def change
    add_column :equipment_records, :is_returnLate, :boolean, default: false
  end
end

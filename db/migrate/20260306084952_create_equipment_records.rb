class CreateEquipmentRecords < ActiveRecord::Migration[8.1]
  def change
    create_table :equipment_records do |t|
      t.references :user, null: false, foreign_key: true
      t.references :equipment, null: false, foreign_key: true
      t.date :date
      t.time :time
      t.boolean :is_absence

      t.timestamps
    end
  end
end

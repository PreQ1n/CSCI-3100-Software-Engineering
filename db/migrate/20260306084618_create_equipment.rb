class CreateEquipment < ActiveRecord::Migration[8.1]
  def change
    create_table :equipment do |t|
      t.string :name, null:false
      t.integer :quantity

      t.timestamps
    end
  end
end

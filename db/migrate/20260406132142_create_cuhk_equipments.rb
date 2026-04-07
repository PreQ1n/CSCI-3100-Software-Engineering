class CreateCuhkEquipments < ActiveRecord::Migration[8.1]
  def change
    create_table :cuhk_equipments do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end

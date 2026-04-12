class DropCuhkEquipmentsTable < ActiveRecord::Migration[8.1]
  def change
    drop_table :cuhk_equipments
  end
end

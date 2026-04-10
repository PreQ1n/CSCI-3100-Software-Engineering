class AddDescriptionToEquipments < ActiveRecord::Migration[8.1]
  def change
    add_column :equipment, :description, :string
  end
end

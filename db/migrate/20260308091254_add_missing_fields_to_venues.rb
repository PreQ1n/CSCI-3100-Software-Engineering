class AddMissingFieldsToVenues < ActiveRecord::Migration[8.1]
  def change
    # 避免重複加入欄位
    unless column_exists?(:venues, :venue_id)
      add_column :venues, :venue_id, :string
      add_index :venues, :venue_id, unique: true
    end

    unless column_exists?(:venues, :building)
      add_column :venues, :building, :string
    end

    # 如果你之後還想加 index 給 name
    unless index_exists?(:venues, :name)
      add_index :venues, :name
    end
  end
end

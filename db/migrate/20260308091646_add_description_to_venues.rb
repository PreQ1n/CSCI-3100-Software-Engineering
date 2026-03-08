class AddDescriptionToVenues < ActiveRecord::Migration[8.1]
  def change
    # 避免重複加入欄位，安全起見用 unless 保護
    unless column_exists?(:venues, :venue_id)
      add_column :venues, :venue_id, :string
      add_index :venues, :venue_id, unique: true
    end

    unless column_exists?(:venues, :building)
      add_column :venues, :building, :string
    end

    unless column_exists?(:venues, :description)
      add_column :venues, :description, :text
    end

    # 如果 name 還沒有 index，也可以補上
    unless index_exists?(:venues, :name)
      add_index :venues, :name
    end
  end
end

class AddVenueIdToVenues < ActiveRecord::Migration[8.1]
  def change
    unless column_exists?(:venues, :venue_id)
      add_column :venues, :venue_id, :string
      add_index :venues, :venue_id, unique: true
    end
  end
end

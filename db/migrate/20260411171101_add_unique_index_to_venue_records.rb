class AddUniqueIndexToVenueRecords < ActiveRecord::Migration[8.1]
  # db/migrate/..._add_unique_index_to_venue_records.rb
  def change
    add_index :venue_records, [:venue_id, :date, :time], unique: true
  end
end

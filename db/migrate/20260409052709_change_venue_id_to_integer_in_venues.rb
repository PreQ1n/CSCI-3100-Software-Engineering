class ChangeVenueIdToIntegerInVenues < ActiveRecord::Migration[8.1]
  def up
    change_column :venues, :venue_id, :integer
  end
  def down
    change_column :venues, :venue_id, :string
  end
end

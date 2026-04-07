class CreateVenues < ActiveRecord::Migration[8.1]
  def change
    unless table_exists?(:venues)
      create_table :venues do |t|
        t.string :name
        t.string :venue_id
        t.string :building
        t.text :description

        t.timestamps
      end

      add_index :venues, :name
      add_index :venues, :venue_id, unique: true
    end
  end
end

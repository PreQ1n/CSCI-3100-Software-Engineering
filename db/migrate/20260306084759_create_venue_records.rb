class CreateVenueRecords < ActiveRecord::Migration[8.1]
  def change
    create_table :venue_records do |t|
      t.references :user, null: false, foreign_key: true
      t.references :venue, null: false, foreign_key: true
      t.date :date, null: false
      t.time :time, null: false
      t.boolean :is_absence 

      t.timestamps
    end
  end
end

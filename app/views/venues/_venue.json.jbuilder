json.extract! venue, :id, :name, :venue_id, :building, :description, :created_at, :updated_at
json.url venue_url(venue, format: :json)

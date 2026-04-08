json.extract! venue_record, :id, :created_at, :updated_at
json.url venue_record_url(venue_record, format: :json)

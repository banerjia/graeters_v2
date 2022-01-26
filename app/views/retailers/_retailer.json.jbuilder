json.extract! retailer, :id, :name, :url, :active, :created_at, :updated_at
json.url retailer_url(retailer, format: :json)

module ElasticsearchStores
    extend ActiveSupport::Concern

    included do
        include Elasticsearch::Model
        include Elasticsearch::Model::Callbacks

        settings do
            mapping dynamic: false do 
                indexes :id, type: "keyword", index: false
                indexes :name, type: "text", analyzer: "stop"
                indexes :address, type: "text"
                indexes :state do
                    indexes :code, type: "keyword"
                    indexes :name, type: "keyword"
                end
                indexes :retailer do
                    indexes :id, type: "keyword"
                    indexes :name, type: "text", analyzer: "stop" do 
                        indexes :raw, type: "keyword"
                    end
                    indexes :url, type: "keyword"
                end
                indexes :location, type: "geo_point"
                indexes :region, type: "text"
            end
        end

        
        # Method provided for ES Callback when there are any ActiveRecord changes
        def as_indexed_json(options={})
        return_value = {}

        # Store name for ES combines the store number if one is present
        store_name = self.name
        store_name += " - %s" % [self.other_attribute.properties["store_number"]] \
                            unless self.other_attribute.nil? || self.other_attribute.properties["store_number"].blank?

        # Basic information hash
        return_value = {
            id: self.id,
            name: store_name,
            location: {lat: self.latitude, lon: self.longitude},
            address: self.address,
            state: {
                code: self.state.code,
                name: self.state.name
            },
            retailer: {
                id: self.retailer.id,
                name: self.retailer.name,
                url: self.retailer.url
            }
        }

        # Region information is added if one is present
        return_value[:region] = self.other_attribute.properties["region"] \
                            unless self.other_attribute.nil? || self.other_attribute.properties["region"].blank?

        return_value.as_json
        end

        # Class Method provided to update/refresh index for stors
        def self.import

        # Outer and Inner JOINS are used so that a sing
        stores = self.left_outer_joins(:other_attribute).joins(:retailer, :state).includes(:state, :retailer, :other_attribute)
        
        # Processing the records in batches
        stores.find_in_batches do |batched_stores|      
            Store.__elasticsearch__.client.bulk({
            index: Store.__elasticsearch__.index_name,
            type: Store.__elasticsearch__.document_type,

            # Create an array of ES documents corresponding to the 
            # ES mapping for Stores
            body: batched_stores.map{ |store| {index: {_id: store.id, data: store.as_indexed_json}}}
            })
        end

        end
    end
end
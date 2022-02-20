class StoresController < ApplicationController
    before_action :set_retailer 
    before_action :set_store, only: [:show]

    
    @@_page_size = 10

    def index

        page = (params[:page] || 1).to_i
        record_offset = (page - 1) * @@_page_size

        # Join vs Include - an INCLUDE will produce two queries while a JOIN will 
        # produce one INNER JOIN query that is much more efficient than two 
        # queries. This will eventually be replaced by an Elastic Search query
        # Alternatively, pagination may be an equally good option. 

        @
        @stores = Store \
                    .left_outer_joins(:other_attribute)
                    .joins(:state) \
                    .where({retailer_id: @retailer.id}) \
                    .offset( record_offset )
                    .limit( @@_page_size )
                    .select('stores.name, stores.addr_ln_1, stores.addr_ln_2, stores.city, states.state_code, stores.zip_code, other_attributes.data')
    end

    def show
    end

    private
    def set_retailer
        @retailer = Retailer.where({url: params[:retailer]}).select([:id, :name]).first()
    end

    def set_store
        @store = Store.find(params[:id])
    end
end

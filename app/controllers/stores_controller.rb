class StoresController < ApplicationController
    before_action :set_retailer 
    before_action :set_store, only: [:show]

    # @@ defines a class variable
    @@retailer_id = nil

    def index
        # Join vs Include - an INCLUDE will produce two queries while a JOIN will 
        # produce one INNER JOIN query that is much more efficient than two 
        # queries. This will eventually be replaced by an Elastic Search query
        # Alternatively, pagination may be an equally good option. 
        @stores = Store \
                    .joins(:state) \
                    .where({retailer_id: @@retailer_id}) \
                    .select("stores.*, states.state_code")
    end

    def show
    end

    private
    def set_retailer
        retailer = Retailer.where({url: params[:retailer]}).select(:id).first
        @@retailer_id = retailer.id
    end

    def set_store
        @store = Store.find(params[:id])
    end
end

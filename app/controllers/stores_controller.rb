class StoresController < ApplicationController
    before_action :set_retailer, :set_state_code
    before_action :set_store, only: [:show]

    
    @@_page_size = 10

    def index

        page = (params[:page] || 1).to_i
        record_offset = (page - 1) * @@_page_size

        # Join vs Include - an INCLUDE will produce two queries while a JOIN will 
        # produce one INNER JOIN query that is much more efficient than two 
        # queries. This will eventually be replaced by an Elastic Search query
        # Alternatively, pagination may be an equally good option. 

        <<-NonESSearch
        @stores = Store \
                    .left_outer_joins(:other_attribute)
                    .joins(:state) \
                    .where({retailer_id: @retailer.id}) \
                    .offset( record_offset )
                    .limit( @@_page_size )
                    .select('stores.name, stores.addr_ln_1, stores.addr_ln_2, stores.city, states.code, stores.zip_code, other_attributes.data')
        NonESSearch
        from = ((params[:page] || 1).to_i - 1) * @@_page_size

        es_query_bool_filter = [{ term: {"retailer.id": @retailer.id}}]
        if !@state.nil?
            es_query_post_filter = {term: {"state.code": @state.code}} unless @state.nil?
        else
            es_query_post_filter = {match_all:{}}
        end

        es_search_results = Store.search({
            from: from,
            size: @@_page_size,
            query:{
                bool:{
                    must: [],
                    must_not: [],
                    should: [],
                    filter: es_query_bool_filter
                }
            },
            aggs:{
                states:{
                    terms:{
                        field: "state.agg_key",
                        size: 50,
                        order:{
                            "_key":"asc"
                        }
                    }
                },
                regions:{
                    terms:{
                        field: "region.raw",
                        size: 10
                    }
                }
            },
            post_filter: es_query_post_filter
        })

        @stores = es_search_results.results
        @aggregations = es_search_results.aggregations
        @results_found = es_search_results.results.total
        @pages = (@results_found/@@_page_size).ceil()
        @params = params

    end

    def show
    end

    private
    def set_retailer
        @retailer = Retailer.where({url: params[:retailer]}).select([:id, :name]).first()
    end

    def set_state_code
        @state = State.find_by_code(params[:state_code])
    end

    def set_store
        @store = Store.find(params[:id])
    end
end

class RetailersController < ApplicationController

    def index
        @retailer_id = params[:retailer]
    end
end
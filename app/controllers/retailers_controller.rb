class RetailersController < ApplicationController
    before_action :set_retailer, only: [:show]

    def index
        @retailers = Retailer \
                        .where({active: true}) \
                        .select([:name, :url]) \
                        .order({ name: :asc})
    end

    def show
        
    end

    private

    def set_retailer
        @retailer = Retailer.where({ url: params[:retailer]}).first()
    end
end
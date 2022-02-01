class RetailersController < ApplicationController
    before_action :set_retailer

    def show
        
    end

    private

    def set_retailer
        @retailer = Retailer.where({ url: params[:retailer]}).first()
    end
end
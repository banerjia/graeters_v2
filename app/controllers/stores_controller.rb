class StoresController < ApplicationController
    before_action :get_retailer 
    def index
        @stores = Store.joins(:state).where({retailer_id: @retailer_id}).select("stores.*, states.state_code")
    end

    private
    def get_retailer
        retailer = Retailer.where({url: params[:retailer]}).select(:id).first
        @retailer_id = retailer.id
    end
end

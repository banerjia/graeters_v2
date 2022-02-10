class RetailersController < ApplicationController
    before_action :set_retailer, only: [:show]

    def index
        recent_range = 7.days.ago.beginning_of_day..Time.now
        @retailers_with_new_stores = Retailer \
                        .where({
                                active: true})\
                        .select([:id, :name, :url, :latest_store_add_date]) \
                        .order({ latest_store_add_date: :desc})
        @recently_updated_retailers = Retailer \
                        .where({
                                active: true})\
                        .select([:id, :name, :url, :updated_at]) \
                        .order({ updated_at: :desc})
        
        exclude_retailers = @retailers_with_new_stores.map{|r| r.id }
        exclude_retailers = exclude_retailers + @recently_updated_retailers.map{|r| r.id }
        exclude_retailers.uniq!
        @retailers = Retailer \
                        .where({active: true}) \
                        .where.not({id: exclude_retailers})
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
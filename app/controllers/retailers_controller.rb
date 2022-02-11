class RetailersController < ApplicationController
    before_action :set_retailer, only: [:show]

    def index
        recent_range = 7.days.ago.beginning_of_day..Time.now

        @retailers_with_new_stores = Retailer \
                        .where({latest_store_add_date: recent_range})
                        .select([:id, :name, :url, :latest_store_add_date]) \
                        .order({ latest_store_add_date: :desc})
        @recently_commented_retailers = Retailer \
                        .where(latest_comment_date: recent_range)
                        .select([:id, :name, :url, :latest_comment_date]) \
                        .order({ latest_comment_date: :desc})
        @all_retailers = Retailer \
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
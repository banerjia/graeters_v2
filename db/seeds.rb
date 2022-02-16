# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

require 'csv'
require 'ruby-slugify'
require 'json'

seed_tables = ['retailers', 'stores', 'states','store_attributes']


# Clear all tables
ActiveRecord::Base.connection.execute('SET FOREIGN_KEY_CHECKS = 0')
seed_tables.each do |table|
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE `#{table}`")
end
ActiveRecord::Base.connection.execute('SET FOREIGN_KEY_CHECKS = 1')

# Clear Elasticsearch Indexes
Store.__elasticsearch__.client.indices.delete index: Store.index_name rescue nil

# Populate US States
us_states = CSV.parse(File.read('db/us-states.csv'), headers: true)

us_states.each do |state|
    State.create({
                    country_code: state['Country'],
                    state_code: state['Abbreviation'],
                    state_name: state['State']
                })
end

# Populate Retailers

<<-DUMMY_SEED
Retailer.create({name: "Krogers", url: "krogers", active: true, created_at: 1.month.ago, updated_at: 1.month.ago})
Retailer.create({name: "Winn Dixie", url: "winn-dixie", active: true, created_at: 1.day.ago, updated_at: 1.day.ago})
Retailer.create({name: "Publix", url: "publix", active: true, created_at: 6.days.ago, updated_at: 6.days.ago})
DUMMY_SEED

graeters_companies = CSV.parse(File.read('db/retailers.csv'), headers: true)

graeters_companies.each do |company|
    if company['url_part'] == '_NA_'
        newObj = RubySlugify.new(company['name'])
        slug = newObj.createSlug()
    else
        slug = company['url_part']
    end
    
    Retailer.create!({
        name: company['name'],
        created_at: company['creaated_at'],
        url: slug,
        stores_count: company['stores_count'].to_i,
        updated_at: company['updated_at']
    })
end

# Temporary Reference to Regions
graeters_regions = CSV.parse(File.read('db/regions.csv'), headers: true)

# Populate Stores
graeters_stores = CSV.parse(File.read('db/stores.csv'), headers: true)
graeters_stores.each do |store|
    s = Store.new({
        name: store['name'],
        retailer_id: store['company_id'],
        addr_ln_1: store['street_address'],
        addr_ln_2: store['suite'],
        city: store['city'],
        state_id: State.where({state_code: store['state_code']}).first.id,
        zip_code: store['zip'],
        latitude: store['latitude'].to_f,
        longitude: store['longitude'].to_f,
        active: store['active'].to_i,
        created_at: store['created_at'],
        updated_at: store['updated_at']
    })

    # Create Store Attributes
    attribs = {}
    src_attribs = ['locality', 'county', 'phone', 'store_number']
    src_attribs.each do |src_attr|
        attribs[src_attr] = store[src_attr] unless store[src_attr] == '_NA_' || store[src_attr].blank?
    end
    selected_region = graeters_regions.select { |region| region['id'] == store['region_id']}
    attribs['region'] = selected_region.first['name'] if selected_region.any?

    if attribs.any?
        s.build_store_attribute({
            attr: attribs.to_json
        })
    end
    s.save
end

<<-DUMMY_SEED
# Populate Stores for Retailer

retailer_krogers = Retailer.where({url: 'krogers'}).first
i = 1
sample_store_addresses.each do |address|
    retailer_krogers.stores.create!({
        name: "Sample Store {i}",
        addr_ln_1: address[:addr_ln_1],
        city: address[:city],
        state: State.where({state_code: address[:state_code]}).first
    })
    i = i+1
end
DUMMY_SEED


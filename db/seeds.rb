# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

require 'csv'

seed_tables = ['retailers', 'stores', 'states']
sample_store_addresses = [
    {addr_ln_1: '8266 Sobax Dr', city: 'Indianapolis', state_code: 'IN'},
    {addr_ln_1: '15520 Bethesda Cir', city: 'Westfield', state_code: 'IN'},
    {addr_ln_1: '611 Perimeter Dr', city: 'Erlanger', state_code: 'KY'},
    {addr_ln_1: '10288 Templeton Ln', city: 'Fort Myers', state_code: 'FL'},
]

# Clear all tables
ActiveRecord::Base.connection.execute('SET FOREIGN_KEY_CHECKS = 0')
seed_tables.each do |table|
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE `#{table}`")
end
ActiveRecord::Base.connection.execute('SET FOREIGN_KEY_CHECKS = 1')

# Populate Retailers

Retailer.create({name: "Krogers", url: "krogers", active: true, created_at: 1.month.ago, updated_at: 1.month.ago})
Retailer.create({name: "Winn Dixie", url: "winn-dixie", active: true, created_at: 1.day.ago, updated_at: 1.day.ago})
Retailer.create({name: "Publix", url: "publix", active: true, created_at: 6.days.ago, updated_at: 6.days.ago})

# Populate US States
us_states = CSV.parse(File.read('db/us-states.csv'), headers: true)

us_states.each do |state|
    State.create({
                    country_code: state['Country'],
                    state_code: state['Abbreviation'],
                    state_name: state['State']
                })
end

# Populate Stores for Retailer

retailer_krogers = Retailer.where({url: 'krogers'}).first
i = 1
sample_store_addresses.each do |address|
    retailer_krogers.stores.create!({
        name: "Sample Store #{i}",
        addr_ln_1: address[:addr_ln_1],
        city: address[:city],
        state: State.where({state_code: address[:state_code]}).first
    })
    i = i+1
end

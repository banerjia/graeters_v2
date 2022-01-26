# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

Company.create({name: "Krogers", url: "krogers", active: true, created_at: DateTime.now - 7.days})
Company.create({name: "Winn Dixie", url: "winn-dixie", active: true, created_at: DateTime.now - 5.days})
Company.create({name: "Publix", url: "publix", active: true, created_at: DateTime.now - 6.days})

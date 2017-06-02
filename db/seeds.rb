# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

r=User.new
r.cellphone = "13429972285"
r.password = "123456"
r.password_confirmation = "123456"
r.is_admin = true
r.default_address_id = "1"
r.save

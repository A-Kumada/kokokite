# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Admin.create!(
    email: ENV['ADMIN_MAIL'],
    password: ENV['ADMINPASS']
)

Tag.create([
  { name: '簡単' },
  { name: '便利' },
  { name: '自炊' },
  { name: 'キッチン' },
  { name: '100均グッズ' },
  { name: '時短' },
  { name: 'リビング' },
  { name: 'お風呂' },
  { name: '整理整頓' },
  { name: '節約' }
])

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
user = User.new(
    :name              => 'Meteor',
    :account          => 'admin',
    :password              => '1q2w3e4r',
    :password_confirmation => '1q2w3e4r',
    :role =>'administrator'
)
user.save
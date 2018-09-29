# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

person_params = -> do
  { first_name: Faker::Name.first_name, last_name: Faker::Name.last_name }
end

movie_params = -> do
  { title: Faker::Movie.quote, release_date: Faker::Date.between(50.years.ago, Date.today) }
end

roles = %w(actor actress director producer)

50.times do
  movie = Movie.create!(movie_params.call)

  5.times do
    person = Person.create!(person_params.call)
    role = roles.sample

    Role.create!(name: role, person_id: person.id, movie_id: movie.id)

    left_overs = roles.sample(rand(roles.length)) - [role]

    left_overs.each do |r|
      movie_id = Movie.all.select(:id).sample(10).pluck(:id).sample
      Role.create!(name: r, person_id: person.id, movie_id: movie_id)
    end
  end
end


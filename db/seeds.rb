person_params = -> do
  { first_name: Faker::Name.first_name, last_name: Faker::Name.last_name }
end

movie_params = -> do
  { title: Faker::Movie.quote, release_date: Faker::Date.between(50.years.ago, Date.today) }
end

alias_params = -> do
  { name: Faker::Internet.username }
end

roles = %w(actor actress director producer)

50.times do
  movie = Movie.create!(movie_params.call)

  5.times do
    person = Person.create!(person_params.call)

    2.times do
      Alias.create!(name: Faker::Internet.username, person_id: person.id)
    end

    role = roles.sample

    Role.create!(name: role, person_id: person.id, movie_id: movie.id)

    left_overs = roles.sample(rand(roles.length)) - [role]

    left_overs.each do |r|
      movie_id = Movie.all.select(:id).sample(10).pluck(:id).sample
      Role.create!(name: r, person_id: person.id, movie_id: movie_id)
    end
  end
end

User.create!(email: 'user@itcrowd.local', password: 'ITCrowd092018')

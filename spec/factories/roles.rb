FactoryBot.define do
  factory :role do
    movie
    person
  end

  factory :actor_role, class: 'Role' do
    name { 'actor' }
  end

  factory :actress_role, class: 'Role' do
    name { 'actress' }
  end

  factory :director_role, class: 'Role' do
    name { 'director' }
  end

  factory :producer_role, class: 'Role' do
    name { 'producer' }
  end
end

json.id person.id
json.first_name person.first_name
json.last_name person.last_name

json.aliases person.aliases, :id, :name

json.movies do
  json.as_actor person.movies.as_role('actor'), :id, :title
  json.as_actress person.movies.as_role('actress'), :id, :title
  json.as_director person.movies.as_role('director'), :id, :title
  json.as_producer person.movies.as_role('producer'), :id, :title
end

json.id movie.id
json.title movie.title
json.release_year movie.release_year
json.release_year_in_roman_numerals movie.release_year_in_roman_numerals

json.directors movie.directors, :id, :first_name, :last_name
json.producers movie.producers, :id, :first_name, :last_name
json.casting movie.casting, :id, :first_name, :last_name

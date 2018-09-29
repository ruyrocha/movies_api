class Person < ApplicationRecord
  has_many :aliases
  has_many :roles
  has_many :movies, through: :roles
end

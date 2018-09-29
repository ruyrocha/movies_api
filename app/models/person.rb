class Person < ApplicationRecord
  has_many :aliases
  has_many :roles
  has_many :movies, through: :roles

  validates :first_name, :last_name, presence: true
end

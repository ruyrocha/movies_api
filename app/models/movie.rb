class Movie < ApplicationRecord
  has_many :roles
  has_many :people, through: :roles

  with_options through: :roles, source: :person do
    has_many :directors, -> { where("roles.name = ?", "director") }
    has_many :producers, -> { where("roles.name = ?", "producer") }
    has_many :actors, -> { where("roles.name = ?", "actor") }
    has_many :actress, -> { where("roles.name = ?", "actress") }
  end

  scope :as_actor, -> { where("roles.name = ?", 'actor') }
  scope :as_actress, -> { where("roles.name = ?", 'actress') }
  scope :as_director, -> { where("roles.name = ?", 'director') }
  scope :as_producer, -> { where("roles.name = ?", 'producer') }

  # Public: Gets casting for a given movie.
  #
  # Returns Array.
  def casting
    [actors + actress].flatten
  end

  # Public: Gets release year.
  #
  # Returns Integer
  def release_year
    release_date.year
  end

  # Public: Gets release year in roman numerals.
  #
  # Returns String.
  def release_year_in_roman_numerals
    year_to_roman(release_year)
  end

  private

  def year_to_roman(number = self, result = "")
    return result if number == 0

    roman_mapping.keys.each do |divisor|
      quotient, modulus = number.divmod(divisor)
      result << roman_mapping[divisor] * quotient
      return year_to_roman(modulus, result) if quotient > 0
    end
  end

  def roman_mapping
    {
      1000 => "M",
      900  => "CM",
      500  => "D",
      400  => "CD",
      100  => "C",
      90   => "XC",
      50   => "L",
      40   => "XL",
      10   => "X",
      9    => "IX",
      5    => "V",
      4    => "IV",
      1    => "I"
    }
  end
end

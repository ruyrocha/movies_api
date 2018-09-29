class Alias < ApplicationRecord
  belongs_to :person

  validates :name, presence: true
end

class Role < ApplicationRecord
  belongs_to :person
  belongs_to :movie

  before_save :set_name

  private

  def set_name
    self.name = name.downcase
  end
end

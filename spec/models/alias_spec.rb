require 'rails_helper'

RSpec.describe Alias, type: :model do
  it { is_expected.to belong_to(:person) }
  it { is_expected.to validate_presence_of(:name) }
end

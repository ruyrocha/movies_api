require 'rails_helper'

RSpec.describe Movie, type: :model do
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:release_date) }

  let!(:movie) { create(:movie) }

  describe "#release_year" do
    it 'returns year of release' do
      expect(movie.release_year).to be_an(Integer)
    end
  end

  describe "#release_year_in_roman_numerals" do
    before do
      movie.release_year = Date.new(2000)
    end

    it 'returns year in roman numerals' do
      expect(movie.release_year_in_roman_numerals).to eq "MM"
    end
  end
end

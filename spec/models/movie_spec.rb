require 'rails_helper'

RSpec.describe Movie, type: :model do
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:release_date) }

  it { is_expected.to have_many(:roles) }
  it { is_expected.to have_many(:people).through(:roles) }

  it { is_expected.to have_many(:directors) }
  it { is_expected.to have_many(:producers) }
  it { is_expected.to have_many(:actors) }
  it { is_expected.to have_many(:actresses) }

  let!(:movie) { create(:movie) }
  let(:actor)    { create(:person) }
  let(:actress)  { create(:person) }
  let(:director) { create(:person) }

  before do
    create(:actor_role, person_id: actor.id, movie_id: movie.id)
    create(:actress_role, person_id: actress.id, movie_id: movie.id)
  end

  describe "::as_role" do
    it 'returns movies worked as a given role' do
      expect(actor.movies.as_role('actor')).to include movie
    end
  end

  describe "#casting" do
    it 'returns actors + actresses for movie' do
      expect(movie.casting).to include actor
      expect(movie.casting).to include actress
      expect(movie.casting).not_to include director
    end
  end

  describe "#release_year" do
    it 'returns year of release' do
      expect(movie.release_year).to eq movie.release_date.year
    end
  end

  describe "#release_year_in_roman_numerals" do
    before do
      movie.release_date = Date.new(2000)
    end

    it 'returns year in roman numerals' do
      expect(movie.release_year_in_roman_numerals).to eq "MM"
    end
  end
end

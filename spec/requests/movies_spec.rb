require 'rails_helper'

RSpec.describe "Movies", type: :request do
  let!(:movies) { create_list(:movie, 5) }

  let(:first_movie) { movies.first }
  let(:last_movie)  { movies.last }

  describe "GET /movies" do
    before { get movies_path }

    it { expect(response).to have_http_status(:ok) }
    it { expect(response.body).to include first_movie.title }
    it { expect(response.body).to include last_movie.title }

    it 'shows release year in roman numerals' do
      body = JSON.parse(response.body)
      movie = body.detect { |b| b["id"] == first_movie.id }
      expect(movie["release_year_in_roman_numerals"]).to eq first_movie.release_year_in_roman_numerals
    end
  end

  describe "GET /movies/:id" do
    context "success" do
      before { get movie_path(first_movie) }

      it { expect(response).to have_http_status(:ok) }

      it 'caches the result' do
        headers = response.headers
        expect(headers["Cache-Control"]).to eq "public"

        expect(headers["Last-Modified"]).to eq first_movie.updated_at.httpdate
      end

      subject { JSON.parse(response.body) }

      it 'returns the right object' do
        expect(subject["id"]).to eq first_movie.id
        expect(subject["title"]).to eq first_movie.title
        expect(subject["release_year"]).to eq first_movie.release_year
      end
    end

    context "failure" do
      let(:invalid_id) { rand(5_000_000..6_000_000) }

      before { get movie_path(invalid_id) }

      it { expect(response).to have_http_status(:not_found) }
      it { expect(JSON.parse(response.body)["message"]).to include "Couldn't find Movie with" }
    end
  end

  describe "POST /movies" do
    let(:movie_params) do
      { movie: { title: Faker::Movie.quote, release_date: rand(10).years.ago } }
    end

    before { post movies_path, params: movie_params }

    it { expect(response).to have_http_status(:ok) }
  end

  describe "PATCH/PUT /movies/:id" do
    let(:movie_params) do
      { movie: { title: "A new title :)" } }
    end

    before { put movie_path(last_movie), params: movie_params }

    it { expect(response).to have_http_status(:ok) }
  end

  describe "DELETE /movies/:id" do
    before { delete movie_path(last_movie) }

    it { expect(response).to have_http_status(:ok) }
  end
end

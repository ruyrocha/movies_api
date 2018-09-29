require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "Movies" do
  header "Content-Type", "application/json"

  let(:pass)  { Faker::Internet.password }
  let(:user)  { create(:user, password: pass) }
  let(:token) { AuthenticateUserCommand.call(user.email, pass)&.result }

  get "/movies" do
    example "Listing movies" do
      explanation "Retrieve all of the movies."

      2.times { create(:movie) }

      do_request

      expect(status).to eq(200)
    end
  end

  get "/movies/:id" do
    parameter :id, "Movie ID."

    let(:movie) { create(:movie) }
    let(:id)    { movie.id }

    example "Showing a movie" do
      do_request

      expect(status).to eq(200)
    end
  end

  post "/movies" do
    with_options scope: :movie do
      parameter :title, "Movie title.", type: :string, required: true
      parameter :release_date, "Date of release.", type: :datetime, required: true
    end

    let(:title) { 'Some Title' }
    let(:release_date) { 3.years.ago }
    let(:raw_post) { params.to_json }

    context "201" do
      example 'Creating a movie as an authenticated user' do
        header "Authorization", "Bearer #{token}"

        do_request

        expect(status).to eq(201)
      end
    end
  end

  put "/movies/:id" do
    with_options scope: :movie do
      parameter :title, "Movie title.", type: :string
      parameter :release_date, "Date of release.", type: :string
    end

    let(:title) { 'New Title' }
    let(:raw_post) { params.to_json }
    let(:movie) { create(:movie) }
    let(:id) { movie.id }

    context "204" do
      example 'Updating a movie' do
        header "Authorization", "Bearer #{token}"

        do_request

        expect(status).to eq(204)
      end
    end
  end

  delete "/movies/:id" do
    let(:movie) { create(:movie) }
    let(:id) { movie.id }

    context "204" do
      example 'Deleting a movie' do
        header "Authorization", "Bearer #{token}"

        do_request

        expect(status).to eq(204)
      end
    end
  end
end

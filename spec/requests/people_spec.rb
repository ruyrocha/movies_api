require 'rails_helper'

RSpec.describe "People", type: :request do
  let(:pass)  { Faker::Internet.password }
  let(:user)  { create(:user, password: pass) }
  let(:token) { AuthenticateUserCommand.call(user.email, pass)&.result }

  let(:authorization_header) do
    { 'Authorization' => "Bearer #{token}" }
  end

  let!(:people)    { create_list(:person, 4) }
  let!(:actor)    { people.first }
  let!(:actress)  { people.last }
  let!(:director) { people[1] }
  let!(:producer) { people[2]}
  let!(:movie)    { create(:movie) }

  before do
    create(:actor_role, person_id: actor.id, movie_id: movie.id)
    create(:producer_role, person_id: producer.id, movie_id: movie.id)
    create(:actress_role, person_id: actress.id, movie_id: movie.id)
    create(:director_role, person_id: director.id, movie_id: movie.id)
  end

  describe "GET /people" do
    before { get people_path }

    it { expect(response).to have_http_status(:ok) }
    it { expect(response.body).to include actor.first_name }
    it { expect(response.body).to include director.last_name }
  end

  describe "GET /people/:id" do
    context "success" do
      before { get person_path(actress) }

      it { expect(response).to have_http_status(:ok) }

      it 'caches the result' do
        headers = response.headers
        expect(headers["Cache-Control"]).to eq "public"

        expect(headers["Last-Modified"]).to eq actress.updated_at.httpdate
      end

      subject { JSON.parse(response.body) }

      it 'returns the right object' do
        expect(subject["id"]).to eq actress.id
        expect(subject["first_name"]).to eq actress.first_name
        expect(subject["last_name"]).to eq actress.last_name
      end

      it 'includes movies and their respective roles' do
        expect(subject["movies"]["as_actress"]).to eq ([{
          id: movie.id, title: movie.title
        }].as_json)
      end
    end

    context "failure" do
      let(:invalid_id) { rand(5_000_000..6_000_000) }

      before { get person_path(invalid_id) }

      it { expect(response).to have_http_status(:not_found) }
      it { expect(JSON.parse(response.body)["message"]).to include "Couldn't find Person with" }
    end
  end

  describe "POST /people" do
    let(:person_params) do
      { person: attributes_for(:person) }
    end

    context "success" do
      before { post people_path, params: person_params, headers: authorization_header }

      it { expect(response).to have_http_status(:created) }
    end

    context "failure" do
      before { post people_path, params: person_params }

      it { expect(response).to have_http_status(:unauthorized) }
    end
  end

  describe "PATCH/PUT /people/:id" do
    let(:person_params) do
      { person: { first_name: 'New Name' } }
    end

    context "success" do
      before { put person_path(actor), params: person_params, headers: authorization_header }

      it { expect(response).to have_http_status(:no_content) }
    end

    context "failure" do
      before { put person_path(actor), params: person_params }

      it { expect(response).to have_http_status(:unauthorized) }
    end
  end

  describe "DELETE /people/:id" do
    context "sucess" do
      before { delete person_path(actress), headers: authorization_header }

      it { expect(response).to have_http_status(:no_content) }
    end

    context "failure" do
      before { delete person_path(actress) }

      it { expect(response).to have_http_status(:unauthorized) }
    end
  end
end

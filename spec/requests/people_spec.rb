require 'rails_helper'

RSpec.describe "People", type: :request do
  let!(:actors)    { create_list(:actor, 2) }
  let!(:actresses) { create_list(:actress, 2) }
  let!(:directors) { create_list(:director, 2) }
  let!(:producers) { create_list(:producer, 2) }

  describe "GET /people" do
    before { get people_path }

    it { expect(response).to have_http_status(:ok) }
    it { expect(response.body).to include actors.first.first_name }
    it { expect(response.body).to include directors.last.last_name }
  end

  describe "GET /people/:id" do
    context "success" do
      let(:actress) { actresses.first }
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
        expect(subject["type"]).to eq 'Actress'
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
      { person: attributes_for(:actor) }
    end

    before { post people_path, params: person_params }

    it { expect(response).to have_http_status(:ok) }
  end

  describe "PATCH/PUT /people/:id" do
    let(:person_params) do
      { person: { first_name: 'New Name' } }
    end

    before { put person_path(actresses.last), params: person_params }

    it { expect(response).to have_http_status(:ok) }
  end

  describe "DELETE /people/:id" do
    before { delete person_path(actresses.last) }

    it { expect(response).to have_http_status(:ok) }
  end
end

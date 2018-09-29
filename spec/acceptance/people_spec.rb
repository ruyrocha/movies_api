require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "People" do
  header "Content-Type", "application/json"

  let(:pass)  { Faker::Internet.password }
  let(:user)  { create(:user, password: pass) }
  let(:token) { AuthenticateUserCommand.call(user.email, pass)&.result }

  let(:first_name) { Faker::Name.first_name }
  let(:last_name)  { Faker::Name.last_name }

  let(:raw_post) { params.to_json }

  get "/people" do
    example "Listing people" do
      explanation "Retrieve all of the people."

      2.times { create(:person) }

      do_request

      expect(status).to eq(200)
    end
  end

  get "/people/:id" do
    parameter :id, "Person ID."

    let(:person) { create(:person) }
    let(:id)     { person.id }

    example "Showing a person" do
      do_request

      expect(status).to eq(200)
    end
  end

  post "/people" do
    with_options scope: :person do
      parameter :first_name, "First name.", type: :string, required: true
      parameter :last_name, "Last name.", type: :string, required: true
    end

    context "201" do
      example 'Creating a person as an authenticated user' do
        header "Authorization", "Bearer #{token}"

        do_request

        expect(status).to eq(201)
      end
    end
  end

  put "/people/:id" do
    with_options scope: :person do
      parameter :first_name, "First name.", type: :string, required: true
      parameter :last_name, "Last name.", type: :string, required: true
    end

    let(:first_name) { 'New Name' }
    let(:person) { create(:person) }
    let(:id) { person.id }

    context "204" do
      example 'Updating a person' do
        header "Authorization", "Bearer #{token}"

        do_request

        expect(status).to eq(204)
      end
    end
  end

  delete "/people/:id" do
    let(:person) { create(:person) }
    let(:id) { person.id }

    context "204" do
      example 'Deleting a person' do
        header "Authorization", "Bearer #{token}"

        do_request

        expect(status).to eq(204)
      end
    end
  end
end

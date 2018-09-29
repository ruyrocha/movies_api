require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "Authentication" do
  header "Content-Type", "application/json"

  let(:pass)  { Faker::Internet.password }
  let(:user)  { create(:user, password: pass) }

  post "/auth" do
    parameter :email, "Email address.", required: true, type: :string
    parameter :password, "Password.", required: true, type: :string

    let(:email)    { user.email }
    let(:password) { pass }
    let(:raw_post) { params.to_json }

    example "Authenticate and get a JSON Web Token" do
      do_request

      expect(status).to eq(200)
    end
  end
end

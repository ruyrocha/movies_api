require 'rails_helper'

RSpec.describe Role, type: :model do
  it { is_expected.to belong_to(:movie) }
  it { is_expected.to belong_to(:person) }

  context "callbacks" do
    let!(:role) { create(:role, name: "JUSTATEST") }

    it 'sets name to downcase' do
      expect(role.reload.name).to eq 'justatest'
    end
  end
end

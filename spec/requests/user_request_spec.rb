require "rails_helper"

RSpec.describe "Users", type: :request do
  RSpec.shared_context "with multiple companies" do
    let!(:company_1) { create(:company) }
    let!(:company_2) { create(:company) }

    before do
      5.times do
        create(:user, company: company_1)
      end
      5.times do
        create(:user, company: company_2)
      end
    end
  end

  RSpec.shared_context "with multiple defined users" do
    before do
      create(:user, username: "leonardo")
      create(:user, username: "leandro")
      create(:user, username: "robert")
    end
  end

  describe "#index" do
    let(:result) { JSON.parse(response.body) }

    context "when fetching users by company" do
      include_context "with multiple companies"

      it "returns only the users for the specified company" do
        get company_users_path(company_1)

        expect(result.size).to eq(company_1.users.size)
        expect(result.map { |element| element["id"] }).to eq(company_1.users.ids)
      end
    end

    context "when fetching all users" do
      include_context "with multiple defined users"

      it "returns all the users with 'le' in the username" do
        get users_path(username: "le")

        expect(result.size).to eq(2)
        expect(result.collect { |r| r["username"] }.sort).to eq(["leandro", "leonardo"])
      end

      it "return all the users with 'rob' in the username" do
        get users_path(username: "rob")
        expect(result.size).to eq(1)
        expect(result[0]["username"]).to eq("robert")
      end

      it "return an empty result when no users is found" do
        get users_path(username: "rodrigo")
        expect(result.size).to eq(0)
      end
    end
  end
end

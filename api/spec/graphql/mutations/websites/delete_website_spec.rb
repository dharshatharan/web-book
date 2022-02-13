# frozen_string_literal: true

require "rails_helper"
RSpec.describe("Delete Website") do
  before do
    @user = create(:user, email: "user@email.com", username: "username", password: "password")
    prepare_query_variables({})
    prepare_context({})
  end

  describe Mutations::Websites::DeleteWebsite do
    it "if conditions are valid, website is succesfully deleted" do
      prepare_context({
        current_user: @user,
      })

      website = create(:website, owner_id: @user.id)

      query = <<~GRAPHQL
        mutation deleteWebsite($id: Int!) {
          deleteWebsite(input: { id: $id }){
              id
          }
        }
      GRAPHQL

      prepare_query(query)

      prepare_query_variables(
        id: website.id
      )

      result = graphql!

      expect(result["data"]["deleteWebsite"]["id"].to_i).to(eq(website.id))
      expect(Website.all.size).to(eq(0))
    end

    it "if website id is invalid, error is returned" do
      prepare_context({
        current_user: @user,
      })

      query = <<~GRAPHQL
        mutation deleteWebsite($id: Int!) {
          deleteWebsite(input: { id: $id }){
              id
          }
        }
      GRAPHQL

      prepare_query(query)

      prepare_query_variables(
        id: 100
      )

      result = graphql!

      expect(result["errors"][0]["message"]).to(eq("ERROR: Website of given ID is nil"))
    end

    it "if website id is invalid, error is returned" do
      prepare_context({
        current_user: @user,
      })

      user2 = create(:user, email: "user2@email.com", username: "username2", password: "password")
      website = create(:website, owner_id: user2.id)

      query = <<~GRAPHQL
        mutation deleteWebsite($id: Int!) {
          deleteWebsite(input: { id: $id }){
              id
          }
        }
      GRAPHQL

      prepare_query(query)

      prepare_query_variables(
        id: website.id
      )

      result = graphql!

      expect(result["errors"][0]["message"]).to(eq("ERROR: Current User is not the owner of this Website"))
    end

    it "if not logged in, error is returned" do
      website = create(:website, owner_id: @user.id)

      query = <<~GRAPHQL
        mutation deleteWebsite($id: Int!) {
          deleteWebsite(input: { id: $id }){
              id
          }
        }
      GRAPHQL

      prepare_query(query)

      prepare_query_variables(
        id: website.id
      )

      result = graphql!

      expect(result["errors"][0]["message"]).to(eq("ERROR: Not logged in or missing token"))
    end
  end
end

# frozen_string_literal: true

require "rails_helper"
RSpec.describe("Update Website") do
  before do
    @user = create(:user, email: "user@email.com", username: "something", password: "1234")
    prepare_query_variables({})
    prepare_context({})
  end

  describe Mutations::Websites::UpdateWebsite do
    it "if conditions are valid, website is succesfully updates" do
      prepare_context({
        current_user: @user,
      })

      website = create(:website, owner_id: @user.id)

      query = <<~GRAPHQL
        mutation updateWebsite($id: Int!, $url: String!) {
          updateWebsite(input: { id: $id, url: $url }){
              id
              url
          }
        }
      GRAPHQL

      prepare_query(query)

      prepare_query_variables(
        id: website.id,
        url: "https://www.test.com"
      )

      result = graphql!

      expect(result["data"]["updateWebsite"]["id"].to_i).to(eq(website.id))
      expect(result["data"]["updateWebsite"]["url"]).to(eq(Website.last.url))
    end

    it "if website id is invalid, error is returned" do
      prepare_context({
        current_user: @user,
      })

      query = <<~GRAPHQL
        mutation updateWebsite($id: Int!, $url: String!) {
          updateWebsite(input: { id: $id, url: $url }){
              id
              url
          }
        }
      GRAPHQL

      prepare_query(query)

      prepare_query_variables(
        id: 100,
        url: "https://www.test.com"
      )

      result = graphql!

      expect(result["errors"][0]["message"]).to(eq("ERROR: Website of given ID is nil"))
    end

    it "if website id is invalid, error is returned" do
      prepare_context({
        current_user: @user,
      })

      user2 = create(:user, email: "user2@email.com", username: "something2", password: "1234")
      website = create(:website, owner_id: user2.id)

      query = <<~GRAPHQL
        mutation updateWebsite($id: Int!, $url: String!) {
          updateWebsite(input: { id: $id, url: $url }){
              id
              url
          }
        }
      GRAPHQL

      prepare_query(query)

      prepare_query_variables(
        id: website.id,
        url: "https://www.test.com"
      )

      result = graphql!

      expect(result["errors"][0]["message"]).to(eq("ERROR: Current User is not the owner of this Website"))
    end

    it "if not logged in, error is returned" do
      website = create(:website, owner_id: @user.id)

      query = <<~GRAPHQL
        mutation updateWebsite($id: Int!, $url: String!) {
          updateWebsite(input: { id: $id, url: $url }){
              id
              url
          }
        }
      GRAPHQL

      prepare_query(query)

      prepare_query_variables(
        id: website.id,
        url: "https://www.test.com"
      )

      result = graphql!

      expect(result["errors"][0]["message"]).to(eq("ERROR: Not logged in or missing token"))
    end
  end
end

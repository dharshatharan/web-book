# frozen_string_literal: true

require "rails_helper"
RSpec.describe("Create Website") do
  before do
    @user = create(:user, email: "user@email.com", username: "something", password: "1234")
    prepare_query_variables({})
    prepare_context({})
  end

  describe Mutations::Websites::CreateWebsite do
    it "if conditions are valid, website is succesfully created" do
      prepare_context({
        current_user: @user,
      })

      query = <<~GRAPHQL
          mutation createWebsite($url: String!) {
            createWebsite(input: { url: $url } ) {
        id
        owner {
        	id
        	username
        }
            }
          }
      GRAPHQL

      prepare_query(query)

      prepare_query_variables(
        url: "https://www.test.com/"
      )
      result = graphql!
      expect(result["data"]["createWebsite"]["id"].to_i).to(eq(Website.last.id))
    end

    it "if not logged in, return error" do
      query = <<~GRAPHQL
          mutation createWebsite($url: String!) {
            createWebsite(input: { url: $url } ) {
        id
        owner {
        	id
        	username
        }
            }
          }
      GRAPHQL

      prepare_query(query)

      prepare_query_variables(
        url: "https://www.test.com/"
      )
      result = graphql!
      expect(result["errors"][0]["message"]).to(eq("ERROR: Not logged in or missing token"))
    end
  end
end

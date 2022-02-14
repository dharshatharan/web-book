# frozen_string_literal: true

require "rails_helper"
RSpec.describe("Create UserFollowsWebsite") do
  before do
    @user = create(:user, email: "user@email.com", username: "something", password: "1234")
    @user2 = create(:user, email: "user2@email.com", username: "something2", password: "1234")
    prepare_query_variables({})
    prepare_context({})
  end

  describe Mutations::Follows::CreateUserFollowsWebsite do
    it "if using valid records, follow is succesful" do
      prepare_context({
        current_user: @user,
      })

      website_test = create(:website, owner: @user2)

      query = <<~GRAPHQL
        mutation createUserFollowsWebsite($websiteId: ID!) {
            createUserFollowsWebsite(input: { websiteId: $websiteId })
        }
      GRAPHQL

      prepare_query(query)

      prepare_query_variables(
        websiteId: website_test.id,
      )

      result = graphql!
      expect(result["data"]["createUserFollowsWebsite"]).to(eq("Succesfully followed website."))
    end

    it "if website id is invalid, return error" do
      prepare_context({
        current_user: @user,
      })

      query = <<~GRAPHQL
        mutation createUserFollowsWebsite($websiteId: ID!) {
            createUserFollowsWebsite(input: { websiteId: $websiteId })
        }
      GRAPHQL

      prepare_query(query)

      prepare_query_variables(
        websiteId: 100,
      )

      result = graphql!
      expect(result["errors"][0]["message"]).to(eq("ERROR: Website of given ID is nil"))
    end

    it "if not logged in, return error" do
      website_test = create(:website, owner: @user2)

      query = <<~GRAPHQL
        mutation createUserFollowsWebsite($websiteId: ID!) {
            createUserFollowsWebsite(input: { websiteId: $websiteId })
        }
      GRAPHQL

      prepare_query(query)

      prepare_query_variables(
        websiteId: website_test.id,
      )

      result = graphql!
      expect(result["errors"][0]["message"]).to(eq("ERROR: Not logged in or missing token"))
    end

    it "if user already follows a website, return error" do
      website_test = create(:website, owner: @user2)
      create(:user_follows_website, user: @user, website: website_test)

      prepare_context({
        current_user: @user,
      })

      query = <<~GRAPHQL
        mutation createUserFollowsWebsite($websiteId: ID!) {
            createUserFollowsWebsite(input: { websiteId: $websiteId })
        }
      GRAPHQL

      prepare_query(query)

      prepare_query_variables(
        websiteId: website_test.id,
      )

      result = graphql!
      expect(result["errors"][0]["message"]).to(eq("ERROR: User already follows Website"))
    end
  end

  it "if user follows a website they own, return error" do
    website_test = create(:website, owner_id: @user.id)

    prepare_context({
      current_user: @user,
    })

    query = <<~GRAPHQL
      mutation createUserFollowsWebsite($websiteId: ID!) {
      		createUserFollowsWebsite(input: { websiteId: $websiteId })
      }
    GRAPHQL

    prepare_query(query)

    prepare_query_variables(
      websiteId: website_test.id,
    )

    result = graphql!
    expect(result["errors"][0]["message"]).to(eq("ERROR: User cannot follow their own Website"))
  end
end

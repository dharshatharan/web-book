# frozen_string_literal: true

require "rails_helper"
RSpec.describe("Unfollow Website") do
  before do
    @user = create(:user, email: "user@email.com", username: "username", password: "password")
    @user2 = create(:user, email: "user2@email.com", username: "username2", password: "password")
    prepare_query_variables({})
    prepare_context({})
  end

  describe Mutations::Follows::DeleteUserFollowsWebsite do
    it "if conditions are valid, website is succesfully unfollowed" do
      prepare_context({
        current_user: @user,
      })

      website = create(:website, owner: @user2)
      create(:user_follows_website, website: website, user: @user)

      query = <<~GRAPHQL
        mutation deleteUserFollowsWebsite($websiteId: Int!) {
          deleteUserFollowsWebsite(input: { websiteId: $websiteId })
        }
      GRAPHQL

      prepare_query(query)

      prepare_query_variables(
        websiteId: website.id
      )

      result = graphql!

      expect(result["data"]["deleteUserFollowsWebsite"]).to(eq("Successfully unfollowed Website"))
      expect(UserFollowsWebsite.all.size).to(eq(0))
    end

    it "if website id is invalid, error is returned" do
      prepare_context({
        current_user: @user,
      })

      website = create(:website, owner: @user2)
      create(:user_follows_website, website: website, user: @user)

      query = <<~GRAPHQL
        mutation deleteUserFollowsWebsite($websiteId: Int!) {
          deleteUserFollowsWebsite(input: { websiteId: $websiteId })
        }
      GRAPHQL

      prepare_query(query)

      prepare_query_variables(
        websiteId: website.id + 1
      )

      result = graphql!

      expect(result["errors"][0]["message"]).to(eq("ERROR: Website of given ID is nil"))
    end

    it "if user doesn't follow website, error is returned" do
      prepare_context({
        current_user: @user,
      })

      website = create(:website, owner: @user2)

      query = <<~GRAPHQL
        mutation deleteUserFollowsWebsite($websiteId: Int!) {
          deleteUserFollowsWebsite(input: { websiteId: $websiteId })
        }
      GRAPHQL

      prepare_query(query)

      prepare_query_variables(
        websiteId: website.id
      )

      result = graphql!

      expect(result["errors"][0]["message"]).to(eq("ERROR: User does not follow this website"))
    end

    it "if not logged in, error is returned" do
      website = create(:website, owner: @user2)
      create(:user_follows_website, website: website, user: @user)

      query = <<~GRAPHQL
        mutation deleteUserFollowsWebsite($websiteId: Int!) {
          deleteUserFollowsWebsite(input: { websiteId: $websiteId })
        }
      GRAPHQL

      prepare_query(query)

      prepare_query_variables(
        websiteId: website.id
      )

      result = graphql!

      expect(result["errors"][0]["message"]).to(eq("ERROR: Not logged in or missing token"))
    end

    it "if user if owner of website, error is returned" do
      prepare_context({
        current_user: @user,
      })

      website = create(:website, owner: @user)
      create(:user_follows_website, website: website, user: @user)

      query = <<~GRAPHQL
        mutation deleteUserFollowsWebsite($websiteId: Int!) {
          deleteUserFollowsWebsite(input: { websiteId: $websiteId })
        }
      GRAPHQL

      prepare_query(query)

      prepare_query_variables(
        websiteId: website.id
      )

      result = graphql!

      expect(result["errors"][0]["message"]).to(eq("ERROR: User cannot unfollow their own Website"))
    end
  end
end

# frozen_string_literal: true

require "rails_helper"
RSpec.describe("Create UserFollowsTag") do
  before do
    @user = create(:user, email: "user@email.com", username: "something", password: "1234")
    @user2 = create(:user, email: "user2@email.com", username: "something2", password: "1234")
    prepare_query_variables({})
    prepare_context({})
  end

  describe Mutations::Follows::CreateUserFollowsTag do
    it "if using valid records, follow is succesful" do
      prepare_context({
        current_user: @user,
      })

      tag_test = create(:tag)

      query = <<~GRAPHQL
        mutation createUserFollowsTag($tagId: ID!) {
            createUserFollowsTag(input: { tagId: $tagId })
        }
      GRAPHQL

      prepare_query(query)

      prepare_query_variables(
        tagId: tag_test.id,
      )

      result = graphql!
      expect(result["data"]["createUserFollowsTag"]).to(eq("Succesfully followed tag."))
    end

    it "if tag id is invalid, return error" do
      prepare_context({
        current_user: @user,
      })

      query = <<~GRAPHQL
        mutation createUserFollowsTag($tagId: ID!) {
            createUserFollowsTag(input: { tagId: $tagId })
        }
      GRAPHQL

      prepare_query(query)

      prepare_query_variables(
        tagId: 100,
      )

      result = graphql!
      expect(result["errors"][0]["message"]).to(eq("ERROR: Tag of given ID is nil"))
    end

    it "if not logged in, return error" do
      tag_test = create(:tag)

      query = <<~GRAPHQL
        mutation createUserFollowsTag($tagId: ID!) {
            createUserFollowsTag(input: { tagId: $tagId })
        }
      GRAPHQL

      prepare_query(query)

      prepare_query_variables(
        tagId: tag_test.id,
      )

      result = graphql!
      expect(result["errors"][0]["message"]).to(eq("ERROR: Not logged in or missing token"))
    end

    it "if user already follows a tag, return error" do
      tag_test = create(:tag)
      create(:user_follows_tag, user: @user, tag: tag_test)

      prepare_context({
        current_user: @user,
      })

      query = <<~GRAPHQL
        mutation createUserFollowsTag($tagId: ID!) {
            createUserFollowsTag(input: { tagId: $tagId })
        }
      GRAPHQL

      prepare_query(query)

      prepare_query_variables(
        tagId: tag_test.id,
      )

      result = graphql!
      expect(result["errors"][0]["message"]).to(eq("ERROR: User already follows Tag"))
    end
  end
end

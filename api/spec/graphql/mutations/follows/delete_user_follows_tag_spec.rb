# frozen_string_literal: true

require "rails_helper"
RSpec.describe("Unfollow Tag") do
  before do
    @user = create(:user, email: "user@email.com", username: "username", password: "password")
    prepare_query_variables({})
    prepare_context({})
  end

  describe Mutations::Follows::DeleteUserFollowsTag do
    it "if conditions are valid, tag is succesfully unfollowed" do
      prepare_context({
        current_user: @user,
      })

      tag = create(:tag)
			create(:user_follows_tag, tag: tag, user: @user)

      query = <<~GRAPHQL
        mutation deleteUserFollowsTag($tagId: Int!) {
          deleteUserFollowsTag(input: { tagId: $tagId })
        }
      GRAPHQL

      prepare_query(query)

      prepare_query_variables(
        tagId: tag.id
      )

      result = graphql!

      expect(result["data"]["deleteUserFollowsTag"]).to(eq("Successfully unfollowed Tag"))
      expect(UserFollowsTag.all.size).to(eq(0))
    end

    it "if tag id is invalid, error is returned" do
      prepare_context({
        current_user: @user,
      })

			tag = create(:tag)
			create(:user_follows_tag, tag: tag, user: @user)

      query = <<~GRAPHQL
        mutation deleteUserFollowsTag($tagId: Int!) {
          deleteUserFollowsTag(input: { tagId: $tagId })
        }
      GRAPHQL

      prepare_query(query)

      prepare_query_variables(
        tagId: tag.id + 1
      )

      result = graphql!

      expect(result["errors"][0]["message"]).to(eq("ERROR: Tag of given ID is nil"))
    end

    it "if user doesn't follow tag, error is returned" do
      prepare_context({
        current_user: @user,
      })

			tag = create(:tag)

      query = <<~GRAPHQL
        mutation deleteUserFollowsTag($tagId: Int!) {
          deleteUserFollowsTag(input: { tagId: $tagId })
        }
      GRAPHQL

      prepare_query(query)

      prepare_query_variables(
        tagId: tag.id
      )

      result = graphql!

      expect(result["errors"][0]["message"]).to(eq("ERROR: User does not follow this tag"))
    end

    it "if not logged in, error is returned" do
      tag = create(:tag)
			create(:user_follows_tag, tag: tag, user: @user)

      query = <<~GRAPHQL
        mutation deleteUserFollowsTag($tagId: Int!) {
          deleteUserFollowsTag(input: { tagId: $tagId })
        }
      GRAPHQL

      prepare_query(query)

      prepare_query_variables(
        tagId: tag.id
      )

      result = graphql!

      expect(result["errors"][0]["message"]).to(eq("ERROR: Not logged in or missing token"))
    end
  end
end

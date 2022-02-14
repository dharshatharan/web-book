# frozen_string_literal: true

require "rails_helper"
RSpec.describe("Add Website Tag") do
  before do
    @user = create(:user, email: "user@email.com", username: "something", password: "1234")
    prepare_query_variables({})
    prepare_context({})
  end

  describe Mutations::Websites::AddWebsiteTag do
    it "if conditions are valid, tag is succesfully added" do
      prepare_context({
        current_user: @user,
      })

      website = create(:website, owner_id: @user.id)

      query = <<~GRAPHQL
        mutation addWebsiteTag($websiteId: Int!, $tag: String!) {
          addWebsiteTag(input: { websiteId: $websiteId, tag: $tag })
        }
      GRAPHQL

      prepare_query(query)

      prepare_query_variables(
        websiteId: website.id,
        tag: "test"
      )

      result = graphql!

      expect(result["data"]["addWebsiteTag"]).to(eq("Succesfully added tag to website."))
      expect(Website.first.tags.length).to(eq(1))
      expect(Website.first.tags.first.name).to(eq("test"))
    end

    it "if website already has the desired tag, return an error" do
      prepare_context({
        current_user: @user,
      })

      website = create(:website, owner_id: @user.id)
      tag = create(:tag, name: "test")
      website.tags << tag

      query = <<~GRAPHQL
        mutation addWebsiteTag($websiteId: Int!, $tag: String!) {
          addWebsiteTag(input: { websiteId: $websiteId, tag: $tag })
        }
      GRAPHQL

      prepare_query(query)

      prepare_query_variables(
        websiteId: website.id,
        tag: "test"
      )

      result = graphql!

      expect(result["errors"][0]["message"]).to(eq("ERROR: Website already has this tag"))
    end

    it "if user is not logged in, return an error" do
      website = create(:website, owner_id: @user.id)

      query = <<~GRAPHQL
        mutation addWebsiteTag($websiteId: Int!, $tag: String!) {
          addWebsiteTag(input: { websiteId: $websiteId, tag: $tag })
        }
      GRAPHQL

      prepare_query(query)

      prepare_query_variables(
        websiteId: website.id,
        tag: "test"
      )

      result = graphql!

      expect(result["errors"][0]["message"]).to(eq("ERROR: Not logged in or missing token"))
    end

    it "if website id is not valid, return an error" do
      prepare_context({
        current_user: @user,
      })

      query = <<~GRAPHQL
        mutation addWebsiteTag($websiteId: Int!, $tag: String!) {
          addWebsiteTag(input: { websiteId: $websiteId, tag: $tag })
        }
      GRAPHQL

      prepare_query(query)

      prepare_query_variables(
        websiteId: 100,
        tag: "test"
      )

      result = graphql!

      expect(result["errors"][0]["message"]).to(eq("ERROR: Website of given ID is nil"))
    end
  end
end

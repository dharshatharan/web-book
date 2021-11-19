require "rails_helper"

RSpec.describe("Website Queries") do
  before do
    prepare_query_variables({})
    prepare_context({})

    3.times do
      u = create(:user)
      create(:website, owner_id: u.id)
    end

    @user = create(:user, email: "user@email.com", username: "something", password: "1234")
    create(:website, owner_id: @user.id)
  end

  # describe Queries::Website do
  #   context "when passed the id of the first website" do
  #     it "returns a website with the id of the first website" do
  #       first_website_id = Website.first.id

  #       prepare_query('query website($id: ID!){
  #                       website(id: $id) {
  #                           id
  #                           tags{
  #                             id
  #                           }
  #                           owner{
  #                             id
  #                           }
  #                       }
  #                     }')

  #       prepare_query_variables(
  #         id: first_website_id
  #       )

  #       website_id = graphql!
  #       expect(website_id).to(eq(first_website_id))
  #     end
  #   end
  # end

  # describe Queries::Website do
  #   context "when passed the id of a private website" do
  #     it "does not allow user to view the website" do
  #       last_website_id = Website.last.id

  #       prepare_query('query website($id: ID!){
  #                     website(id: $id) {
  #                         id
  #                     }
  #                     }')

  #       prepare_query_variables(
  #         id: last_website_id
  #       )

  #       response = graphql!["errors"][0]["message"]
  #       expect(response).to(eq("ERROR: Website of given ID is nil"))
  #     end
  #   end

  #   context "when passed invalid website id" do
  #     it "returns error" do
  #       prepare_query('query website($id: ID!){
  #                     website(id: $id) {
  #                         id
  #                     }
  #                     }')

  #       prepare_query_variables(
  #         id: 100
  #       )

  #       response = graphql!["errors"][0]["message"]
  #       expect(response).to(eq("ERROR: Website of given ID is nil"))
  #     end
  #   end
  # end

  # describe Queries::WebsiteSearch do
  #   context "when there are 4 websites in the database with same name, but one is private" do
  #     it "returns a search result with a length of 3 because one is private" do
  #       prepare_query('query{
  #                     websiteSearch(searchInput: "test", page:0, limit:24){
  #                       collection{
  #                         id
  #                       }
  #                     }
  #                   }')

  #       websites = graphql!["data"]["websiteSearch"]["collection"]
  #       expect(websites.length).to(eq(3))
  #     end
  #   end
  # end

  # describe Queries::WebsitesListed do
  #   context "when there are 4 websites in the database with same name, but one is private" do
  #     it "returns a search result with a length of 3 because one is private" do
  #       prepare_query('query{
  #                   websiteListed(page:1, limit:24){
  #                       collection{
  #                         id
  #                       }
  #                     }
  #                   }')

  #       websites = graphql!["data"]["websiteListed"]["collection"]
  #       expect(websites.length).to(eq(3))
  #     end
  #   end
  # end
end
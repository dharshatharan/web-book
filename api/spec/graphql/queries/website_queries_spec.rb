require "rails_helper"

RSpec.describe("Website Queries") do
  before do
    prepare_query_variables({})
    prepare_context({})

    4.times do
      u = create(:user)
      create(:website, domain: "domain.test.com", url: "https://domain.test.com", owner_id: u.id)
    end
  end

  describe Queries::Website do
    context "when passed the id of the first website" do
      it "returns a website with the id of the first website" do
        first_website_id = Website.first.id

        prepare_query('query website($id: ID!){
                        website(id: $id) {
                            id
                        }
                      }')

        prepare_query_variables(
          id: first_website_id
        )

        website_id = graphql!["data"]["website"]["id"].to_i
        expect(website_id).to(eq(first_website_id))
      end
    end
  end

  describe Queries::Website do
    context "when passed invalid website id" do
      it "returns error" do
        prepare_query('query website($id: ID!){
                        website(id: $id) {
                            id
                        }
                      }')

        prepare_query_variables(
          id: 100
        )

        response = graphql!["errors"][0]["message"]
        expect(response).to(eq("ERROR: Website of given ID is nil"))
      end
    end
  end

  describe Queries::WebsiteSearch do
    context "when there are 4 websites in the database with same name, 3 with the word 'test' in the domain" do
      it "returns a search result with a length of 3" do
        prepare_query('query{
                        websiteSearch(searchInput: "test", page:0, limit:24){
                          collection{
                            id
                          }
                        }
                      }')

        websites = graphql!["data"]["websiteSearch"]["collection"]
        expect(websites.length).to(eq(4))
      end
    end
  end

  describe Queries::WebsitesListed do
    context "when there are 4 websites in the database with same name" do
      it "returns a search result with a length of 4" do
        prepare_query('query{
                    websitesListed(page:1, limit:24){
                        collection{
                          id
                        }
                      }
                    }')

        websites = graphql!["data"]["websitesListed"]["collection"]
        expect(websites.length).to(eq(4))
      end
    end
  end
end

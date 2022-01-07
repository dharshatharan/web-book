require "rails_helper"

RSpec.describe("User Queries") do
  before do
    prepare_query_variables({})
    prepare_context({})

    create_list(:user, 2)

    @user = create(:user, email: "user@email.com", password: "1234")
    @website = create(:website, owner: @user)
  end

  describe Queries::Users do
    context "when there are 3 users in the database" do
      it "returns a result with a length of 3" do
        prepare_query('{
                users{
                    id
                }
            }')

        users = graphql!["data"]["users"]
        expect(users.length).to(eq(3))
      end
    end
  end

  describe Queries::User do
    context "when passed a valid user id" do
      it "returns a user with the correct id" do
        first_user_id = User.first.id

        prepare_query('query user($id: ID!){
                user(id: $id) {
                    id
                }
                }')

        prepare_query_variables(
          id: first_user_id
        )

        user_id = graphql!["data"]["user"]["id"].to_i
        expect(user_id).to(eq(first_user_id))
      end
    end

    context "when passed an invalid user id" do
      it "returns a user with the correct id" do
        invalid_id = 100

        prepare_query('query user($id: ID!){
                  user(id: $id) {
                      id
                  }
                  }')

        prepare_query_variables(
          id: invalid_id
        )

        graphql_result = graphql!
        expect(graphql_result["errors"][0]["message"]).to(eq("ERROR: User of given ID is nil"))
      end
    end
  end

  describe Queries::User do
    before do
      3.times do
        website = create(:website, owner: @user)
        create(:user_follows_website, user: @user, website: website)
      end
    end

    context "when user follows 3 websites" do
      it "returns 3 followed_websites" do
        prepare_query('query user($id: ID!){
                user(id: $id) {
                    followedWebsites {
                        id
                    }
                  }
                }')

        prepare_query_variables(
          id: @user.id
        )

        followed_websites = graphql!["data"]["user"]["followedWebsites"]
        expect(followed_websites.length).to(eq(3))
      end
    end
  end

  describe Queries::User do
    before do
      3.times do
        tag = create(:tag)
        create(:user_follows_tag, user: @user, tag: tag)
      end
    end

    context "when user follows 3 tag" do
      it "returns 3 followed_tag" do
        prepare_query('query user($id: ID!){
                user(id: $id) {
                    followedTags {
                        id
                    }
                  }
                }')

        prepare_query_variables(
          id: @user.id
        )

        followed_tag = graphql!["data"]["user"]["followedTags"]
        expect(followed_tag.length).to(eq(3))
      end
    end
  end

  describe Queries::User do
    context "when user has a personal website" do
      before do
        @website = create(:website, owner: @user)
        @user.personal_website = @website
        @user.save
      end

      it "return personal website" do
        prepare_query('query user($id: ID!){
                user(id: $id) {
                    personalWebsite {
                        id
                    }
                  }
                }')

        prepare_query_variables(
          id: @user.id
        )

        personal_website_id = graphql!["data"]["user"]["personalWebsite"]["id"].to_i
        expect(personal_website_id).to(eq(@website.id))
      end
    end

    context "when user does not have a personal website" do
      before do
        @user.personal_website = nil
        @user.save
      end

      it "does not retuen a website" do
        prepare_query('query user($id: ID!){
                user(id: $id) {
                    followedWebsites {
                        id
                    }
                  }
                }')

        prepare_query_variables(
          id: @user.id
        )

        followed_websites = graphql!["data"]["user"]["personalWebsite"]
        expect(followed_websites).to(eq(nil))
      end
    end
  end

  describe Queries::Profile do
    context "when not logged in" do
      it "returns jwt required error" do
        query = 'query profile{
            profile {
                id
            }
            }'

        prepare_query(query)
        error = graphql!["errors"][0]["message"]
        expect(error).to(eq("ERROR: Not logged in or missing token"))
      end
    end
  end

  context Queries::Profile do
    describe GraphqlController, type: :controller do
      context "when logged in" do
        it "succesfully returns user profile" do
          query = 'query profile{
            profile {
                id
            }
            }'

          # send request with the token of the user we pretended to login
          user_id = { id: @user.id }
          token = JWT.encode(user_id, Rails.application.secrets.secret_key_base.byteslice(0..31))
          headers = { Authentication: token }
          request.headers.merge!(headers)
          post :execute, params: { query: query }

          # receive response
          response_body = JSON.parse(response.body)
          desire_user = User.find_by(email: "user@email.com")
          expect(response_body["data"]["profile"]["id"].to_i).to(eq(desire_user.id))
        end
      end
    end
  end
end

module Types
  class MutationType < Types::BaseObject
    # User
    field :login, mutation: Mutations::Users::Login, description: "Logs in a User and returns a JWT Token"
    field :sign_up, mutation: Mutations::Users::SignUp, description: "Creates a new User using the provided info"
    field :update_user, mutation: Mutations::Users::UpdateUser, description: "Updates the current user using the provided info"

    # Website
    field :create_website, mutation: Mutations::Websites::CreateWebsite, description: "Creates a new Website using the provided info"
    field :update_website, mutation: Mutations::Websites::UpdateWebsite, description: "Updates a Website using the provided info"
    field :delete_website, mutation: Mutations::Websites::DeleteWebsite, description: "Deletes a new Website with a certain ID"
    field :add_website_tag, mutation: Mutations::Websites::AddWebsiteTag, description: "Creates a new Website Tag for the specified website"

    # Follow
    field :create_user_follows_tag, mutation: Mutations::Follows::CreateUserFollowsTag, description: "Create a follow relation to the tag specified for the user"
    field :delete_user_follows_tag, mutation: Mutations::Follows::DeleteUserFollowsTag, description: "Delete a follow relation to the tag specified for the user"
    field :create_user_follows_website, mutation: Mutations::Follows::CreateUserFollowsWebsite, description: "Create a follow relation to the website specified for the user"
    field :delete_user_follows_website, mutation: Mutations::Follows::DeleteUserFollowsWebsite, description: "Delete a follow relation to the website specified for the user"
  end
end

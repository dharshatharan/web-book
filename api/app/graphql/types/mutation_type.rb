module Types
  class MutationType < Types::BaseObject
    # User
    field :login, mutation: Mutations::Users::Login, description: "Logs in a User and returns a JWT Token"
    field :sign_up, mutation: Mutations::Users::SignUp, description: "Creates a new User using the provided info"
    field :update_user, mutation: Mutations::Users::UpdateUser, description: "Updates the current user using the provided info"

  end
end

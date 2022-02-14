module Mutations
  module Users
    # Mutation updates the current user
    class UpdateUser < BaseMutation
      argument :email, String, required: false
      argument :password, String, required: false
      argument :username, String, required: false
      argument :display_name, String, required: false
      argument :avatar, Types::File, required: false

      type Types::UserType

      def resolve(email: nil, password: nil, username: nil, display_name: nil, avatar: nil)
        user = context[:current_user]
        return GraphQL::ExecutionError.new("ERROR: Not logged in or missing token") if user.nil?

        user.email = email if email.present?
        user.password = password if password.present?
        user.username = username if username.present?
        user.username = username if username.present?
        user.avatar = avatar if avatar.present?
        user.save!

        raise GraphQL::ExecutionError, user.errors.full_messages.join(", ") unless user.errors.empty?

        user
      rescue ActiveRecord::RecordInvalid
        GraphQL::ExecutionError.new("ERROR: Username or email is taken")
      end
    end
  end
end

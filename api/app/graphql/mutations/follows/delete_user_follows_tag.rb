module Mutations
  module Follows
    # Mutation unfollows a tag for a user
    class DeleteUserFollowsTag < BaseMutation
			argument :tag_id, Int, required: true

      type String

      def resolve(tag_id:)
        user = context[:current_user]
        return GraphQL::ExecutionError.new("ERROR: Not logged in or missing token") if user.nil?
				return GraphQL::ExecutionError.new("ERROR: Tag of given ID is nil") if Tag.find(tag_id).nil?

        userFollowsTag = ::UserFollowsTag.find_by(user_id: user.id, tag_id: tag_id)

        if userFollowsTag
          userFollowsTag.destroy!
          raise GraphQL::ExecutionError, userFollowsTag.errors.full_messages.join(", ") unless userFollowsTag.errors.empty?

          "Successfully unfollowed Tag"
        else
          raise GraphQL::ExecutionError, "ERROR: User does not follow this tag"
        end
      rescue ActiveRecord::RecordNotFound
        GraphQL::ExecutionError.new("ERROR: Tag of given ID is nil")
      end
    end
  end
end

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

        user_follows_tag = ::UserFollowsTag.find_by(user_id: user.id, tag_id: tag_id)

        if user_follows_tag
          user_follows_tag.destroy!
          raise GraphQL::ExecutionError, user_follows_tag.errors.full_messages.join(", ") unless user_follows_tag.errors.empty?

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

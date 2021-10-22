module Mutations
  module UserFollowsTags
    # Mutation that creates an UserFollowsTag entity with the provided Tag
    class CreateUserFollowsTag < BaseMutation
      argument :tag_id, ID, required: true

      type String

      def resolve(tag_id:)
        user = context[:current_user]
        return GraphQL::ExecutionError.new("ERROR: Not logged in or missing token") if user.nil?

        tag = Tag.find(tag_id)
        return GraphQL::ExecutionError.new("ERROR: Requested Tag does not exist") if tag.nil?
        return GraphQL::ExecutionError.new("ERROR: User cannot follow their own Tag") if user == tag.owner

        ActiveRecord::Base.transaction do
          ::UserFollowsTag.create!(
            user_id: user.id,
            tag_id: tag.id
          )
        end

        "Succesfully followed tag."
      rescue ActiveRecord::RecordInvalid
        GraphQL::ExecutionError.new("ERROR: Invalid operation. Transaction was not successfully completed")
      rescue ActiveRecord::RecordNotFound
        GraphQL::ExecutionError.new("ERROR: Tag of given ID is nil")
      end
    end
  end
end

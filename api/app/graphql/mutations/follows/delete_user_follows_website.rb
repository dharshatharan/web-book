module Mutations
  module Follows
    # Mutation unfollows a website for a user
    class DeleteUserFollowsWebsite < BaseMutation
      argument :website_id, Int, required: true

      type String

      def resolve(website_id:)
        user = context[:current_user]
        return GraphQL::ExecutionError.new("ERROR: Not logged in or missing token") if user.nil?
        return GraphQL::ExecutionError.new("ERROR: Website of given ID is nil") if Website.find(website_id).nil?
        website = ::Website.find(website_id)
        return GraphQL::ExecutionError.new("ERROR: User cannot unfollow their own Website") if website.owner == user

        user_follows_website = ::UserFollowsWebsite.find_by(user_id: user.id, website_id: website_id)

        if user_follows_website
          user_follows_website.destroy!
          raise GraphQL::ExecutionError, user_follows_website.errors.full_messages.join(", ") unless user_follows_website.errors.empty?

          "Successfully unfollowed Website"
        else
          raise GraphQL::ExecutionError, "ERROR: User does not follow this website"
        end
      rescue ActiveRecord::RecordNotFound
        GraphQL::ExecutionError.new("ERROR: Website of given ID is nil")
      end
    end
  end
end

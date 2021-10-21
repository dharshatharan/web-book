module Mutations
  module Websites
    # Mutation deletes the website of the provided id
    class DeleteWebsite < BaseMutation
      argument :id, Int, required: true

      type Types::WebsiteType

      def resolve(id:)
        user = context[:current_user]
        return GraphQL::ExecutionError.new("ERROR: Not logged in or missing token") if user.nil?

        website = ::Website.find(id)

        if website.owner == user
          website.destroy!
          raise GraphQL::ExecutionError, website.errors.full_messages.join(", ") unless website.errors.empty?

          website
        else
          raise GraphQL::ExecutionError, "ERROR: Current User is not the owner of this Website"
        end

      rescue ActiveRecord::RecordNotFound
        GraphQL::ExecutionError.new("ERROR: Website of given ID is nil")
      end
    end
  end
end

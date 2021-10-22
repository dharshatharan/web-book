module Mutations
  module UserFollowsWebsites
    # Mutation that creates an UserFollowsWebsite entity with the provided Website
    class CreateUserFollowsWebsite < BaseMutation
      argument :website_id, ID, required: true

      type String

      def resolve(website_id:)
        user = context[:current_user]
        return GraphQL::ExecutionError.new("ERROR: Not logged in or missing token") if user.nil?

        website = Website.find(website_id)
        return GraphQL::ExecutionError.new("ERROR: Requested Website does not exist") if website.nil?
        return GraphQL::ExecutionError.new("ERROR: User cannot follow their own Website") if user == website.owner

        ActiveRecord::Base.transaction do
          ::UserFollowsWebsite.create!(
            user_id: user.id,
            website_id: website.id
          )
        end

        "Succesfully followed website."
      rescue ActiveRecord::RecordInvalid
        GraphQL::ExecutionError.new("ERROR: Invalid operation. Transaction was not successfully completed")
      rescue ActiveRecord::RecordNotFound
        GraphQL::ExecutionError.new("ERROR: Website of given ID is nil")
      end
    end
  end
end

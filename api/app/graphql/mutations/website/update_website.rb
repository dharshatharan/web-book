module Mutations
  module Websites
    # Mutation updates the website of the provided id
    class UpdateWebsite < BaseMutation
      argument :url, String, required: true

      type Types::WebsiteType

      def resolve(id:, url: nil)
        user = context[:current_user]
        return GraphQL::ExecutionError.new("ERROR: Not logged in or missing token") if user.nil?

        website_search = ::Website.find(id)

        if website_search.owner_id == user.id

          website_search.url = url if title.present?
          website_search.save!

          raise GraphQL::ExecutionError, website_search.errors.full_messages.join(", ") unless website_search.errors.empty?

          website_search
        else
          raise GraphQL::ExecutionError, "ERROR: Current User is not the owner of this Website"
        end

      rescue ActiveRecord::RecordNotFound
        GraphQL::ExecutionError.new("ERROR: Website of given ID is nil")
      end
    end
  end
end

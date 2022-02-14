module Mutations
  module Websites
    # Mutation that creates an Website entity with the provided information
    class CreateWebsite < BaseMutation
      argument :url, String, required: true

      type Types::WebsiteType

      def resolve(url:)
        user = context[:current_user]
        return GraphQL::ExecutionError.new("ERROR: Not logged in or missing token") if user.nil?
        uri = URI(url)
        return GraphQL::ExecutionError.new("ERROR: Invalid URL") if uri.nil? || uri.host.nil?

        ::Website.create!(
          domain: uri.host,
          url: url,
          owner_id: user.id,
        )
      end
    end
  end
end

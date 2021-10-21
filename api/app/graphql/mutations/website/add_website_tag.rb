module Mutations
  module Websites
    # Mutation adds a tag to a given Website
    class AddWebsiteTag < BaseMutation
      argument :website_id, Int, required: true
      argument :tag, String, required: true

      type String

      def resolve(website_id: nil, tag: nil)
        user = context[:current_user]
        return GraphQL::ExecutionError.new("ERROR: Not logged in or missing token") if user.nil?
        return GraphQL::ExecutionError.new("ERROR: User is not owner of this Website") unless ::Website.find(website_id).owner_id == user.id

        tag_search = Tag.find_by(name: tag)

        if tag_search.nil?
          tag_search = Tag.create(
            name: tag
          )
        end

        website_tag_search = WebsiteTag.find_by(website_id: website_id, tag_id: tag_search.id)

        if website_tag_search.nil?
          WebsiteTag.create(
            website_id: website_id,
            tag_id: tag_search.id
          )
        else
          return GraphQL::ExecutionError.new("ERROR: Website already has this tag")
        end

        "Succesfully added tag to website."
      rescue ActiveRecord::RecordNotFound
        GraphQL::ExecutionError.new("ERROR: Website of given ID is nil")
      end
    end
  end
end

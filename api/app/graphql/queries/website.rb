module Queries
  # A Query that returns the information of a given website based on the given id
  class Website < Queries::BaseQuery
    description "Get Website by id"
    argument :id, ID, required: true
    type Types::WebsiteType, null: false

    def resolve(id:)
      website = ::Website.fetch(id)
      return GraphQL::ExecutionError.new("ERROR: Website of given ID is nil") if website.nil? || website.state == "private"

      website
    rescue ActiveRecord::RecordNotFound
      GraphQL::ExecutionError.new("ERROR: Website of given ID is nil")
    end
  end
end

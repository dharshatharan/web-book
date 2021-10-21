module Queries
  # A Query that returns all websites
  class Websites < Queries::BaseQuery
    description "Get Websites"
    argument :page, Integer, required: true
    argument :limit, Integer, required: true
    type Types::WebsiteType.collection_type, null: false

    def resolve(page: nil, limit: nil)
      ::Website.order(id: :desc).page(page).per(limit)
    end
  end
end
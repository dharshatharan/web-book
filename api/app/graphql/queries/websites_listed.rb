module Queries
  # A Query that returns the information of a given website based on the given id
  class WebsitesListed < Queries::BaseQuery
    description "Get Websites by id"
    argument :page, Integer, required: true
    argument :limit, Integer, required: true
    type Types::WebsiteType.collection_type, null: false

    def resolve(page: nil, limit: nil)
      ::Website.order(id: :desc).page(page).per(limit)
    end
  end
end

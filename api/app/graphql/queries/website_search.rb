module Queries
  # A Query that returns the information of a given website based on the given id
  class WebsiteSearch < Queries::BaseQuery
    description "Text based website search query."
    argument :search_input, String, required: true
    argument :page, Integer, required: true
    argument :limit, Integer, required: true
    type Types::WebsiteType.collection_type, null: false

    def resolve(search_input: nil, page: nil, limit: nil)
      websites = ::Website.order(id: :desc)
      results = []
      upper_bound = (page * limit + limit > websites.length ? websites.length : (page * limit + limit)) - 1

      ((page * limit)..upper_bound).each do |i|
        results << websites[i] if websites[i].search_string.downcase.include?(search_input.downcase)
      end

      results
    end
  end
end

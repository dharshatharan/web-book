module Types
  class WebsiteType < Types::BaseObject
    description "A type that represents a single Website entity."

    field :id, ID, null: false
    field :domain, String, null: false
    field :url, String, null: false
    field :owner, String, null: false
    field :tags, [Types::TagType], null: false
    field :followers, [Types::UserType], null: false

    def tags
      Loaders::AssociationLoader.for(Website, :tags).load(object)
    end

    def followers
      Loaders::AssociationLoader.for(Website, :followers).load(object)
    end
  end
end

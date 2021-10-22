module Types
  # Type for Tag Model
  class TagType < Types::BaseObject
    description "A type that represents a single Tag entity"

    field :id, ID, null: false
    field :name, String, null: false
    field :websites, [Types::WebsiteType], null: false

    def websites
      Loaders::AssociationLoader.for(Tag, :websites).load(object)
    end
  end
end

module Types
  class QueryType < Types::BaseObject
    # Add `node(id: ID!) and `nodes(ids: [ID!]!)`
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    field :profile, resolver: Queries::Profile
    field :tags, resolver: Queries::Tags
    field :user, resolver: Queries::User
    field :users, resolver: Queries::Users
    field :website, resolver: Queries::Website
    field :websites, resolver: Queries::Websites
  end
end

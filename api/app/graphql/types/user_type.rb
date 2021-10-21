module Types
  class UserType < Types::BaseObject
		description "A user represents someone that may interact with this API."

    field :id, ID, null: false
    field :email, String, null: true
    field :role, String, null: true
    field :username, String, null: true
    field :display_name, String, null: true
		field :avatar, String, null: false
    field :personal_website_id, Integer, null: true
		field :personal_website, Types::WebsiteType, null: false
		field :followed_websites, [Types::WebsiteType], null: false
		field :followed_tags, [Types::TagType], null: false

		def avatar
      Loaders::ActiveStorageLoader.for(:Image, :attached_image).load(object.id).then do |image|
        Rails.application.routes.url_helpers
          .rails_blob_url(image, only_path: true)
      end
    end

		def personal_website
			Loaders::AssociationLoader.for(User, :personal_website).load(object)
		end

		def followed_websites
			Loaders::AssociationLoader.for(User, :followed_websites).load(object)
		end

		def followed_tags
			Loaders::AssociationLoader.for(User, :followed_tags).load(object)
		end
  end
end

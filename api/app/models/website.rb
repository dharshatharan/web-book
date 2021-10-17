class Website < ApplicationRecord
  # IdentityCache
  include IdentityCache

  # Validations
  validates :domain, presence: true, format: { with: /(?:[a-z0-9](?:[a-z0-9-]{0,61}[a-z0-9])?\.)+[a-z0-9][a-z0-9-]{0,61}[a-z0-9]/, message: "not a valid domain" }
  validates :url, presence: true, format: { with: %r{(http://www\.|https://www\.|http://|https://)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(/.*)?}, message: "not a valid url" }

  # Relations
  belongs_to :user, optional: false
  cache_belongs_to :user
  has_many :website_tags, dependent: :delete_all
  has_many :tags, through: :website_tags
  has_many :user_follows_websites, dependent: :delete_all
end

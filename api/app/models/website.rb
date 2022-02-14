class Website < ApplicationRecord
  # IdentityCache
  include IdentityCache

  # Validations
  validates :domain, presence: true, format: { with: /(?:[a-z0-9](?:[a-z0-9-]{0,61}[a-z0-9])?\.)+[a-z0-9][a-z0-9-]{0,61}[a-z0-9]/, message: "not a valid domain" }
  validates :url, presence: true, format: { with: %r{(http://www\.|https://www\.|http://|https://)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(/.*)?}, message: "not a valid url" }

  # Relations
  belongs_to :owner, class_name: "User", optional: false
  cache_belongs_to :owner
  has_many :website_tags, dependent: :delete_all
  has_many :tags, through: :website_tags
  has_many :user_follows_website, dependent: :delete_all
  has_many :followers, dependent: :delete_all, through: :user_follows_website, source: :user

  def search_string
    owner = self.owner
    Rails.cache.fetch([cache_key, __method__]) do
      s = domain + " " + url + " " + owner.username + " " + owner.display_name + " "
      s + tags.map(&:name).join(", ")
    end
  end
end

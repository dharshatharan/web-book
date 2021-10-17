class User < ApplicationRecord
  # IdentityCache
  include IdentityCache

  # Bcrypt Secure Password
  has_secure_password

  # Validations
  validates :email, presence: true, uniqueness: true
  validates :username, presence: true, uniqueness: true
  validates :role, presence: true, inclusion: { in: ["public", "admin"] }

  # Relations
  has_many :user_follows_websites, dependent: :delete_all
  has_many :user_follows_tags, dependent: :delete_all
  has_many :website_user, dependent: :delete_all
  has_one :personal_website, class_name: "Website", dependent: :delete

  # Active Storage
  has_one_attached :avatar

  # Methods
  def display_name
    super || username
  end

  def attached_image_url
    Rails.cache.fetch([cache_key, __method__]) do
      Rails.application.routes.url_helpers
        .rails_blob_url(avatar, only_path: true)
    end
  end
end

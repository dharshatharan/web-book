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
  belongs_to :personal_website, class_name: "Website", dependent: :destroy, optional: true
  has_many :user_follows_website, dependent: :delete_all
  has_many :followed_websites, through: :user_follows_website, source: :website
  has_many :user_follows_tag, dependent: :delete_all
  has_many :followed_tags, through: :user_follows_tag, source: :tag

  # Active Storage
  has_one_attached :avatar

  # Methods
  def display_name
    super || username
  end

  def avatar_url
    if avatar.attached?
      Rails.cache.fetch([cache_key, __method__]) do
        Rails.application.routes.url_helpers
          .rails_blob_url(avatar, only_path: true)
      end
    end
  end
end

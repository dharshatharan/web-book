class Tag < ApplicationRecord
  # IdentityCache
  include IdentityCache

  # Validations
  validates :name, presence: true, uniqueness: true

  # Relations
  has_many :website_tags, dependent: :delete_all
  has_many :websites, through: :website_tags
end

class WebsiteTag < ApplicationRecord
  # IdentityCache
  include IdentityCache

  # Relations
  belongs_to :website
  belongs_to :tag
end

class UserFollowsWebsite < ApplicationRecord
  # IdentityCache
  include IdentityCache

  # Relations
  belongs_to :user
  belongs_to :website
end

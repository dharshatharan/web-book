class UserFollowsTag < ApplicationRecord
  # IdentityCache
  include IdentityCache

  # Relations
  belongs_to :user
  belongs_to :tag
end

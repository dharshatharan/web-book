class CreateUserFollowsWebsites < ActiveRecord::Migration[6.1]
  def change
    create_table(:user_follows_websites, &:timestamps)
  end
end

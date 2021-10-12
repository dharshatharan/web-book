class CreateUserFollowsTags < ActiveRecord::Migration[6.1]
  def change
    create_table(:user_follows_tags, &:timestamps)
  end
end

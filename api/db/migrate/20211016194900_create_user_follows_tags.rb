class CreateUserFollowsTags < ActiveRecord::Migration[6.1]
  def change
    create_table(:user_follows_tags) do |t|
      t.references(:user, foreign_key: false)
      t.references(:tag, foreign_key: false)

      t.timestamps
    end
  end
end

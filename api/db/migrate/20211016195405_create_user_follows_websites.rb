class CreateUserFollowsWebsites < ActiveRecord::Migration[6.1]
  def change
    create_table(:user_follows_websites) do |t|
      t.references(:user, foreign_key: false)
      t.references(:website, foreign_key: false)

      t.timestamps
    end
  end
end

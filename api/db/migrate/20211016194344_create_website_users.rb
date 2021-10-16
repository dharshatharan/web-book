class CreateWebsiteUsers < ActiveRecord::Migration[6.1]
  def change
    create_table(:website_users) do |t|
      t.string(:role)
      t.references(:website, foreign_key: false)
      t.references(:user, foreign_key: false)

      t.timestamps
    end
  end
end

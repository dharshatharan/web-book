class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table(:users) do |t|
      t.string(:email, unique: true)
      t.string(:password_digest)
      t.string(:role)
      t.string(:username, unique: true)
      t.string(:display_name)
      t.references(:personal_website, foreign_key: false)

      t.timestamps
    end
    change_table(:users, bulk: true) do |t|
      t.index(:email)
      t.index(:username)
      t.index(:display_name)
    end
  end
end

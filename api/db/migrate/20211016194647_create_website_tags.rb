class CreateWebsiteTags < ActiveRecord::Migration[6.1]
  def change
    create_table(:website_tags) do |t|
      t.references(:website, foreign_key: false)
      t.references(:tag, foreign_key: false)

      t.timestamps
    end
  end
end

class CreateWebsiteTags < ActiveRecord::Migration[6.1]
  def change
    create_table(:website_tags, &:timestamps)
  end
end

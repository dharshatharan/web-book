# Migration for adding relation foreign keys to base tables
class AddOwnerToWebsite < ActiveRecord::Migration[6.1]
  def change
    add_reference(:websites, :owner, index: true)
  end
end

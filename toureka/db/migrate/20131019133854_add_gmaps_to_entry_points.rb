class AddGmapsToEntryPoints < ActiveRecord::Migration
  def change
    add_column :entry_points, :gmaps, :boolean
  end
end

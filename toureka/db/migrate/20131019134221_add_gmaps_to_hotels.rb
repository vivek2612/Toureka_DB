class AddGmapsToHotels < ActiveRecord::Migration
  def change
    add_column :hotels, :gmaps, :boolean
  end
end

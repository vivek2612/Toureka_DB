class AddGmapsToTouristSpots < ActiveRecord::Migration
  def change
    add_column :tourist_spots, :gmaps, :boolean
  end
end

class AddTouristSpotConstraints < ActiveRecord::Migration
  def change
  	change_column :tourist_spots, :name, :string, :null => false
  	change_column :tourist_spots, :latitude, :float, :null => false
  	change_column :tourist_spots, :longitude, :float, :null => false
  	change_column :tourist_spots, :districtName, :string, :null => false
  	change_column :tourist_spots, :stateName, :string, :null => false
  	change_column :tourist_spots, :category, :string, :null => false
  end
end

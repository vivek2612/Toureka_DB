class AddMapPointConstraints < ActiveRecord::Migration
  def change
  	change_column :map_points, :districtName, :string, :null => false
  	change_column :map_points, :stateName, :string, :null => false
  	change_column :map_points, :lattitude, :float, :null => false
  	change_column :map_points, :longitude, :float, :null => false
  end
end

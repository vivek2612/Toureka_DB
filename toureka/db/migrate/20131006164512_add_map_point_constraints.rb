class AddMapPointConstraints < ActiveRecord::Migration
  def change
  	change_column :map_points, :latitude, :float, :null => false
  	change_column :map_points, :longitude, :float, :null => false
  end
end

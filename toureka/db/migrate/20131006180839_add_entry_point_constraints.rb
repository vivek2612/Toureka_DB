class AddEntryPointConstraints < ActiveRecord::Migration
  def change
  	change_column :entry_points, :name, :string, :null => false
  	change_column :entry_points, :latitude, :float, :null => false
  	change_column :entry_points, :longitude, :float, :null => false
  	change_column :entry_points, :districtName, :string, :null => false
  	change_column :entry_points, :stateName, :string, :null => false
  end
end

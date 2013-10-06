class AddHotelConstaints < ActiveRecord::Migration
  def change
  	change_column :hotels, :name, :string, :null => false
  	change_column :hotels, :lattitude, :float, :null => false
  	change_column :hotels, :longitude, :float, :null => false
  	change_column :hotels, :districtName, :string, :null => false
  	change_column :hotels, :stateName, :string, :null => false
  end
end

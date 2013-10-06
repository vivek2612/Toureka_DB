class AddDistrictConstraints < ActiveRecord::Migration
  def change
	change_column :districts, :districtName, :string, :null => false
  	change_column :districts, :stateName, :string, :null => false
  	add_index :districts, [:stateName, :districtName], :unique=>true    
  end
end

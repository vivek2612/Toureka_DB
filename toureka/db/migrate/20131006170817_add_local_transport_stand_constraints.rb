class AddLocalTransportStandConstraints < ActiveRecord::Migration
  def change
  	change_column :local_transport_stands, :name, :string, :null => false
  	change_column :local_transport_stands, :lattitude, :float, :null => false
  	change_column :local_transport_stands, :longitude, :float, :null => false
  	change_column :local_transport_stands, :districtName, :string, :null => false
  	change_column :local_transport_stands, :stateName, :string, :null => false
  end
end

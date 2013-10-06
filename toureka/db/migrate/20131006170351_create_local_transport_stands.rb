class CreateLocalTransportStands < ActiveRecord::Migration
  def change
    create_table :local_transport_stands do |t|
      t.float :lattitude
      t.float :longitude
      t.string :name
      t.string :transportType
      t.string :districtName
      t.string :stateName

      t.timestamps
    end
  end
end

class CreateMapPoints < ActiveRecord::Migration
  def change
    create_table :map_points do |t|
      t.float :latitude
      t.float :longitude
      t.string :districtName
      t.string :stateName

      t.timestamps
    end
  end
end

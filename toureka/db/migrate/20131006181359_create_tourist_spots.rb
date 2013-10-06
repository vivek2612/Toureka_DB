class CreateTouristSpots < ActiveRecord::Migration
  def change
    create_table :tourist_spots do |t|
      t.float :lattitude
      t.float :longitude
      t.string :name
      t.float :rating
      t.string :category
      t.text :description
      t.string :districtName
      t.string :stateName

      t.timestamps
    end
  end
end

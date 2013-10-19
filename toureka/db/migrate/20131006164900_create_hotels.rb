class CreateHotels < ActiveRecord::Migration
  def change
    create_table :hotels do |t|
      t.float :latitude
      t.float :longitude
      t.string :name
      t.text :description
      t.string :districtName
      t.string :stateName

      t.timestamps
    end
  end
end

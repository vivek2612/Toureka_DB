class CreateHotels < ActiveRecord::Migration
  def change
    create_table :hotels do |t|
      t.float :lattitude
      t.float :longitude
      t.string :name
      t.text :description
      t.string :districtName
      t.string :stateName

      t.timestamps
    end
  end
end

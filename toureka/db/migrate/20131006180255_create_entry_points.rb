class CreateEntryPoints < ActiveRecord::Migration
  def change
    create_table :entry_points do |t|
      t.float :lattitude
      t.float :longitude
      t.string :name
      t.string :entryType
      t.string :districtName
      t.string :stateName

      t.timestamps
    end
  end
end

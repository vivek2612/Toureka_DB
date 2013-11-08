class CreateEntryPoints < ActiveRecord::Migration
  def change
    execute "CREATE TYPE entryPointType AS ENUM ('railway', 'airport')"
    create_table :entry_points do |t|
      t.float :latitude
      t.float :longitude
      t.string :name
      t.string :districtName
      t.string :stateName
      t.column :entryPointType, "entryPointType"
      t.timestamps
    end
  end
end

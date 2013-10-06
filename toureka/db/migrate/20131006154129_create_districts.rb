class CreateDistricts < ActiveRecord::Migration
  def change
    create_table :districts do |t|
      t.string :districtName
      t.string :stateName

      t.timestamps
    end
  end
end

class CreateDistrictBoundedBies < ActiveRecord::Migration
  def change
    create_table :district_bounded_bies do |t|
      t.integer :district_id
      t.integer :top_left_corner_id
      t.integer :bottom_right_corner_id
      t.timestamps
    end
  end
end

class CreateStateBoundedBies < ActiveRecord::Migration
  def change
    create_table :state_bounded_bies do |t|
      t.integer :state_id
      t.integer :top_left_corner_id
      t.integer :bottom_right_corner_id

      t.timestamps
    end
  end
end

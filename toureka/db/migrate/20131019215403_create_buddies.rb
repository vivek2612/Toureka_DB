class CreateBuddies < ActiveRecord::Migration
  def change
    create_table :buddies do |t|
      t.integer :friend_id
      t.integer :tourist_spot_id
      t.float :distance
      t.timestamps
    end
    execute "ALTER TABLE buddies ADD CONSTRAINT distanceCheck4 CHECK ( distance >= 0 );"
  end
end

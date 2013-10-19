class CreateBuddies < ActiveRecord::Migration
  def change
    create_table :buddies do |t|
      t.integer :friend_id
      t.integer :tourist_spot_id
      t.timestamps
    end
  end
end

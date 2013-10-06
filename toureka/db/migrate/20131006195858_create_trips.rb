class CreateTrips < ActiveRecord::Migration
  def change
    create_table :trips do |t|
    	t.integer :dayNumber
      t.timestamps
    end
  end
end

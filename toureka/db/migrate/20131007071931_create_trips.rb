class CreateTrips < ActiveRecord::Migration
  def change
    create_table :trips do |t|
		t.belongs_to :user
		t.belongs_to :tourist_spot
    	t.date  :startDate
      	t.integer :dayNumber

      	t.timestamps
    end
  end
end

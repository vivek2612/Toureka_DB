class CreateTrips < ActiveRecord::Migration
  def change
    create_table :trips do |t|
		t.belongs_to :user
    	t.date  :start_date
      	t.string :name

      	t.timestamps
    end
  end
end

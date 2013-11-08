class CreateOneDay < ActiveRecord::Migration
  def up
  	create_table :one_days do |t|
		t.belongs_to :user
		t.belongs_to :tourist_spot
		t.date :start_date
    	t.integer :day_number

      	t.timestamps
    end
  end

  def down
  end
end

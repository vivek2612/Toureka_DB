class CreateClosestHotels < ActiveRecord::Migration
  def change
    create_table :closest_hotels do |t|
    	t.belongs_to :entry_point
    	t.belongs_to :hotel
      t.integer :distance

      t.timestamps
    end
  end
end

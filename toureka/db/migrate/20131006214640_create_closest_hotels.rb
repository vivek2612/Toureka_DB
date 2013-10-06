class CreateClosestHotels < ActiveRecord::Migration
  def change
    create_table :closest_hotels do |t|
      t.integer :distance

      t.timestamps
    end
  end
end

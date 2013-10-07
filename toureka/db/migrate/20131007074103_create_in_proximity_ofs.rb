class CreateInProximityOfs < ActiveRecord::Migration
  def change
    create_table :in_proximity_ofs do |t|
    	t.belongs_to :hotel
    	t.belongs_to :tourist_spot
      t.integer :distance

      t.timestamps
    end
  end
end

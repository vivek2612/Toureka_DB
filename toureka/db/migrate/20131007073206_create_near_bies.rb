class CreateNearBies < ActiveRecord::Migration
  def change
    create_table :near_bies do |t|
    	t.belongs_to :hotel
    	t.belongs_to :local_transport_stand
      	t.integer :distance

      	t.timestamps
    end
  end
end

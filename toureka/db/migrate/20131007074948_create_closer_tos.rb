class CreateCloserTos < ActiveRecord::Migration
  def change
    create_table :closer_tos do |t|
    	t.belongs_to :local_transport_stand
    	t.belongs_to :tourist_spot
      t.integer :distance

      t.timestamps
    end
  end
end

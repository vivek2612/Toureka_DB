class CreateCloserTos < ActiveRecord::Migration
  def change
    create_table :closer_tos do |t|
      t.integer :distance

      t.timestamps
    end
  end
end

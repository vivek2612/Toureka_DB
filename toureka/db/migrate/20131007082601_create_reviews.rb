class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
    	t.belongs_to :user
    	t.belongs_to :tourist_spot
      t.text :review

      t.timestamps
    end
  end
end

class AddReviewConstraints < ActiveRecord::Migration
  def change
  	change_column :reviews, :review, :text, :null => false
  end
end

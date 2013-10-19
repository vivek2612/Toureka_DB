class AddRatingToReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :rating, :float
  	execute "ALTER TABLE reviews ADD CONSTRAINT reviewRatingChk CHECK ( rating >= 0 and rating <= 10);"
  end
end

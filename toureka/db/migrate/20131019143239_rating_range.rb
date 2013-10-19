class RatingRange < ActiveRecord::Migration
  def change
  	execute "ALTER TABLE tourist_spots ADD CONSTRAINT ratingChk CHECK ( rating >= 0 and rating <= 10);"
  end

end

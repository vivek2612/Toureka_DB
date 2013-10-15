class CategoryEnum < ActiveRecord::Migration
  def change
  	execute "drop type if exists category_type;" 
  	execute "create type category_type as enum('Art Gallery', 'Historic Site', 'Museum', 'Music Venue', 'Performing Arts Venue', 'Zoo', 'Beach', 'Garden', 'Plaza', 'Religious/Spiritual', 'National Parks');"
  	execute "alter table tourist_spots drop COLUMN \"category\";"
  	execute "alter table tourist_spots add \"category\" category_type;"
  end
end

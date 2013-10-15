class RoleEnum < ActiveRecord::Migration
  def change
  	execute "drop type if exists role_type;" 
  	execute "create type role_type as enum ('reader','writer');"
  	execute "alter table users drop COLUMN \"role\";"
  	execute "alter table users add \"role\" role_type;"
  end
end

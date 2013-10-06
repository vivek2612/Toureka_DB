class User < ActiveRecord::Base
  attr_accessible :password, :role, :username, :password_confirmation
  attr_accessor :password
  has_many :trips , :dependent => :destroy


  before_save :encrypt_password
  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :username
  validates_uniqueness_of :username
end

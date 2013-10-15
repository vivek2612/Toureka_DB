class User < ActiveRecord::Base
  attr_accessible :password, :role, :username, :password_confirmation
  attr_accessor :password
  has_many :trips , :dependent => :destroy

  has_many :reviews

  before_save :encrypt_password
  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :username
  validates_uniqueness_of :username
  validates :role, :inclusion => { :in => ["reader", "writer"] }
end

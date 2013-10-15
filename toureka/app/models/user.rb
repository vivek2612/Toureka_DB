class User < ActiveRecord::Base
  attr_accessible :password, :role, :username, :password_confirmation, :password_salt, :password_hash
  attr_accessor :password
  has_many :trips , :dependent => :destroy

  has_many :reviews

  before_save :encrypt_password
  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :username
  validates_uniqueness_of :username
  validates :role, :inclusion => { :in => ["reader", "writer"] }

  def authenticate(username, password)
    user = User.find_by_username(username)
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      puts "Login Successfull"
      user
    else
      puts "Login Unsuccessfull"
      nil
    end
  end

  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end

end

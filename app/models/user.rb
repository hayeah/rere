class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable, :confirmable,
          :recoverable, :rememberable, :trackable, :validatable

  validates_presence_of :name

  validates_presence_of :username
  validates_uniqueness_of :username
  
  validates_presence_of :email
  validates_uniqueness_of :email
  validates_format_of :email, :with => Devise.email_regexp
  
  validates_presence_of :password
  validates_confirmation_of :password
  
  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :username, :email, :password, :password_confirmation
  
end

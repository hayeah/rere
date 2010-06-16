class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable


  options = nil
  if Rails.env == "production"
    options = {
      :storage => :s3, 
      :s3_credentials => "#{Rails.root}/config/s3.yml", 
      :path => "/:style/:filename"
    }
  else
    options = {}
  end
  
  has_attached_file :avatar, options.merge(:styles => { :medium => "300x300>", :thumb => "90x90>", :tiny => "30x30" })

  validates_presence_of :name

  validates_presence_of :username
  validates_uniqueness_of :username, :message => "is taken"
  INVALID_USERNAMES = %w(admin root group thought groups thoughts user users support about contact no-reply help feedback)
  INVALID_USERNAMES_REGEX = Regexp.compile("^#{INVALID_USERNAMES.map { |str| Regexp.quote(str) }.join("|")}$")
  validates_format_of :username, :without => INVALID_USERNAMES_REGEX, :message => "username is taken"
  
  validates_presence_of :email
  validates_uniqueness_of :email
  validates_format_of :email, :with => Devise.email_regexp

  validates_format_of :username, :with => /^[a-zA-Z0-9_]+$/, :message => "may only contain letters, numbers and _"

  # override devise's authentication search to allow login with either username or email
  def self.find_for_authentication(conditions={})
    if conditions[:username] =~ Devise.email_regexp
      conditions[:email] = conditions[:username]
      conditions.delete(:username)
    end
    super
  end
  
  # validates_presence_of :password
  # validates_confirmation_of :password
  
  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :username, :email, :password, :password_confirmation, :avatar

  has_many :thoughts
  
  has_many :memberships
  has_many :groups, :through => :memberships

  def stream
    StreamThought.for(self)
  end

  def share(content,group=nil)
    Thought.share(content,self,group)
  end

  def follow(user)
    Following.add(user,self)
  end
  
  def unfollow(user)
    Following.remove(user,self)
  end
  
  def following?(user)
    Following.exist?(user,self)
  end

  def followed
    Following.followed_by(self)
  end

  def followers
    Following.followers_of(self)
  end
end

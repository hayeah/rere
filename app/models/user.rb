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
  validates_uniqueness_of :username
  
  validates_presence_of :email
  validates_uniqueness_of :email
  validates_format_of :email, :with => Devise.email_regexp

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
  has_many :groups, :through => :memberships

  # shares is the timeline of thoughts from a user and all watched users
  has_many :shares, :through => :shared_thoughts, :source => :thought
  has_many :shared_thoughts, :as => :subject

  has_many :memberships
  has_many :groups, :through => :memberships

  def stream
    self.thoughts.includes(:comments => [:user]).order("id desc")
  end

  def shared_stream
    self.shares.includes(:comments => [:user]).order("id desc")
  end
  
  def watch(user)
    return if user == self
    Watcher.new(:from_user => self, :to_user => user).save!
  end

  def watching?(user)
    !Watcher.where(:from_user_id => self.id, :to_user_id => user.id).empty?
  end

  def watched
    Watcher.where(:from_user_id => self.id).includes(:to_user).map(&:to_user)
  end

  def watchers
    @watchers ||= Watcher.where(:to_user_id => self.id).includes(:from_user).map(&:from_user)
  end

  def share(content,group=nil)
    User.transaction do
      thought = self.thoughts.create(:content => content)
      # appear in a group's share thoughts
      thought.share(group) if group
      # appear in self's share thoughts
      thought.share(self)
      # appear in each watcher's share thoughts
      self.watchers.each do |watcher|
        thought.share(watcher)
      end
      return thought
    end
  end
end

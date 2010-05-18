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
  
  # validates_presence_of :password
  # validates_confirmation_of :password
  
  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :username, :email, :password, :password_confirmation

  has_many :thoughts
  has_many :groups, :through => :memberships

  # shares is the timeline of thoughts from a user and all watched users
  has_many :shares, :through => :shared_thoughts, :source => :thought
  has_many :shared_thoughts, :as => :subject
  
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

  def share(content)
    User.transaction do
      thought = self.thoughts.create(:content => content)
      # share thoughts with watchers
      (self.watchers+[self]).each do |watcher|
        self.shared_thoughts.create(:thought => thought,
                                    :subject => watcher)
      end
    end
  end
end

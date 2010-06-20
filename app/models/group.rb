class Group < ActiveRecord::Base
  belongs_to :creator, :class_name => "User"
  has_many :members, :through => :memberships, :source => :user
  has_many :memberships
  validates_presence_of :name
  validates_presence_of :description
  validates_presence_of :creator

  validates_uniqueness_of :permalink, :message => "group name is taken"
  validates_presence_of :permalink

  has_many :shares, :through => :shared_thoughts, :source => :thought
  has_many :shared_thoughts, :as => :subject

  before_validation :set_permalink

  # one-to-one mapping from arbitrary group name to permalink
  def set_permalink
    self.name = self.name.strip
    self.permalink = self.name.gsub(/[^[:alnum:]]/,"-").downcase
  end
  
  class BadAuth < StandardError
  end
  
  class << self
    def make(attributes)
      group = self.new(attributes)
      Group.transaction do
        group.add(group.creator)
        group.save!
      end
      group
    end

    def of(user)
      self.find(Membership.where(:user_id => user.id).map(&:group_id))
    end
  end

  def share(content,user)
    # TODO do we allow non-group member to post?
    if member?(user)
      Thought.share(content,user,self)
    else
      raise BadAuth, "non-member cannot share with group"
    end
  end

  def stream
    StreamThought.for(self)
  end
  
  def add(user)
    self.members << user
    self.save
  end

  def remove(user)
    if creator == user
      raise BadAuth, "admin cannot leave group"
    else
      Membership.where(:group_id => self.id,
                       :user_id => user.id).delete_all
    end
    
  end

  def member?(user)
    !Membership.where(:group_id => self.id,
                      :user_id => user.id).empty?
  end
end

class Group < ActiveRecord::Base
  belongs_to :creator, :class_name => "User"
  has_many :members, :through => :memberships, :source => :user
  has_many :memberships
  validates_presence_of :name
  validates_presence_of :description
  validates_presence_of :creator

  has_many :shares, :through => :shared_thoughts, :source => :thought
  has_many :shared_thoughts, :as => :subject
  
  class << self
    def make(attributes)
      group = self.new(attributes)
      group.join(group.creator)
      group.save
      group
    end
  end

  def stream
    self.shares.includes(:comments => [:user]).order("id desc")
  end
  
  def join(user)
    self.members << user
    self.save
  end

  def include?(user)
    !Membership.where(:group_id => self.id,
                      :user_id => user.id).empty?
  end
end

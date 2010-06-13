class Thought < ActiveRecord::Base
  belongs_to :user
  belongs_to :group
  
  has_many :comments

  has_many :shared_thoughts

  validates_presence_of :content

  class << self
    # We select distinct to remove duplicates shared thoughts. This
    # happens when the thought is shared through both a follower
    # relationship and a group membership.
    def for_user(user)
      thought_ids = StreamThought.select("distinct thought_id").
        where(:to_id => user.id,:to_type => user.class.to_s).
        order("thought_id desc").
        limit(25).
        map(&:thought_id)
      Thought.where(:id => thought_ids).includes(:comments => [:user])
    end

    def share(content,user,group=nil)
      t = Thought.create(:content => content,
                         :user => user,
                         :group => group)
      t.broadcast
      t
    end
  end

  def author
    user
  end

  # A thought could be shared twice:
  #
  # 1) through a follower relationship
  # 2) through a group membership
  #
  # We do this because if a user unfollows or leaves a group, the
  # shared thought should be removed from the stream. But as long as
  # one of these relationship still holds, the thought should still be
  # visible in the stream.
  def broadcast
    # add to stream of author
    share(author, author)
    # add to streams of author's followers
    author.followers.each do |follower|
      share(author,follower)
    end
    
    if group
      # add to stream of group
      share(author,group)
      # add to streams of group's members
      group.members.each do |member|
        share(group,member)
      end
    end
  end

  def share(from,to)
    StreamThought.create(:from => from, :to => to, :thought => self)
  end
  
end

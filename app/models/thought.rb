class Thought < ActiveRecord::Base
  belongs_to :user
  belongs_to :group
  
  has_many :comments

  has_many :shared_thoughts

  validates_presence_of :content

  class << self
    def share(content,user,group=nil)
      t = Thought.create(:content => content.strip,
                         :user => user,
                         :group => group)
      t.broadcast
      Notifier.notify_recipient(t).deliver if t.recipient
      t
    end
  end

  def author
    user
  end

  def comment(user,content)
    c = self.comments.create(:user => user,
                             :content => content)
    c.participants.each do |participant|
      Notifier.new_comment(c,participant).deliver
    end
    c
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

  # sends email to "replied to" @user, in twitter's terminology. It's the @user that opens up a tweet.
  def recipient
    if username = Twitter::Extractor.extract_reply_screen_name(content)
      recipient = User.find_by_username(username)
      return recipient unless recipient == author
    end
  end

  def mentions
    User.where(:username => Twitter::Extractor.extract_mentioned_screen_names(content).uniq.compact)
  end

  def share(from,to)
    StreamThought.create(:from => from, :to => to, :thought => self)
  end
  
end

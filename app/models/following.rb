class Following < ActiveRecord::Base
  belongs_to :followed, :class_name => "User"
  belongs_to :follower, :class_name => "User"
  
  class NotReflexive < RuntimeError
  end
  
  class << self
    def add(followed,follower)
      raise NotReflexive if follower == followed
      create!(:follower_id => follower.id, :followed_id => followed.id)
      StreamThought.add_all(followed,follower)
    end

    def remove(followed,follower)
      raise NotReflexive if follower == followed
      where(:follower => follower, :followed => followed).delete_all
      StreamThought.remove_all(followed,follower)
    end

    def exist?(followed,follower)
      !where(:follower_id => follower.id, :followed_id => followed.id).empty?
    end

    # the users followed user
    def followers_of(user)
      where(:followed_id => user.id).includes(:follower).map(&:follower)
    end

    # the users followed by user
    def followed_by(user)
      where(:follower_id => user.id).includes(:followed).map(&:followed)
    end
  end
end

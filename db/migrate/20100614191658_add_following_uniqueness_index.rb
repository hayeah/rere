class AddFollowingUniquenessIndex < ActiveRecord::Migration
  def self.up
    add_index "followings", ["follower_id","followed_id"], :unique => true
  end

  def self.down
    remove_index "followings", ["follower_id","followed_id"], :unique => true
  end
end

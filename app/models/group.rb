class Group < ActiveRecord::Base
  belongs_to :creator, :class_name => "User"
  DB = RedisDB::Group
  class << self
    def join(group_id,user_id)
      DB.sadd(group_id,user_id)
      DB.sadd("User.#{user_id}",group_id)
    end

    def member?(group_id,user_id)
      DB.sismember(group_id,user_id)
    end

    def members(group_id)
      DB.smembers(group_id)
    end

    def groups_of(user_id)
      DB.smembers("User.#{user_id}")
    end
  end

  def members
    @members ||= User.find(Group.members(self.id))
  end
end

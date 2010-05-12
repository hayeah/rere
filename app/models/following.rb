require 'redis'
class Following < OpenStruct
  class << self
    def create(followed,follower)
      db.sadd("#{followed.id}.followers",follower.id)
      db.sadd("#{follower.id}.followings",followed.id)

      # multi isn't working for some reason...
      # db.multi do
      #   db.sadd("#{followed.id}.followers",follower.id)
      #   db.sadd("#{follower.id}.followings",followed.id)
      # end
      
    end

    def followers_count(user)
      db.scard("#{user.id}.followers")
    end

    def followings_count(user)
      db.scard("#{user.id}.followings")
    end

    def following?(followed,follower)
      db.sismember("#{followed.id}.followers",follower.id)
    end

    def followers(user)
      User.find(db.smembers("#{user.id}.followers"))
    end

    def followings(user)
      User.find(db.smembers("#{user.id}.followings"))
    end

    def db
      @db ||= RedisDB::Following
    end

    def flush
      db.flush
    end
  end
end

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


class Group::Thought < OpenStruct
  DB = RedisDB::GroupThought
  
  class << self
    def create(group_id,user,content)
      id = next_id
      attributes = {
        "oid" => id,
        "author" => user.attributes.slice("id","username","name"),
        "content" => content,
        "time" => Time.now.xmlschema
      }
      json = attributes.to_json
      # push to my own personal stream
      DB.lpush(group_id,json)
    end

    def find(group_id,from=0,limit=25)
      DB.lrange(group_id,from,from+limit).map { |json|
        Group::Thought.new(from_json(json))
      }
    end
    
    def from_json(json)
      attributes = JSON.parse(json)
      attributes["time"] = Time.parse(attributes["time"])
      attributes
    end

    def next_id
      DB.incr("#id")
    end
  end

  def comments
    Group::Comment.find(self.oid)
  end
end

class Group::Comment < OpenStruct
  DB = RedisDB::GroupComment
  
  class << self
    def create(thought_oid,user,content)
      DB.lpush(thought_oid,{
                 "oid" => next_id,
                 "author" => user.attributes.slice("id","username","name"),
                 "content" => content,
                 "time" => Time.now.xmlschema}.to_json)
    end

    def find(thought_oid,from=0,limit=25)
      comments = DB.lrange(thought_oid,from,from+limit).map { |json|
        Group::Comment.new(from_json(json))
      }
    end

    def from_json(json)
      attributes = JSON.parse(json)
      attributes["time"] = Time.parse(attributes["time"])
      attributes
    end

    def next_id
      DB.incr("#id")
    end
  end
end

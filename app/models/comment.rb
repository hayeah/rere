require 'redis'
class Comment < OpenStruct
  class << self
    def save(thought_oid,user,content)
      db.lpush(thought_oid,{
                 "oid" => next_id,
                 "author" => user.attributes.slice("id","username","name"),
                 "content" => content,
                 "time" => Time.now.xmlschema}.to_json)
    end

    def find(thought_oid,from=0,limit=25)
      comments = db.lrange(thought_oid,from,from+limit).map { |json|
        Comment.new(from_json(json))
      }
    end

    def db
      @db ||= RedisDB::Comment
    end

    def flush
      db.flush
    end
    
    def from_json(json)
      attributes = JSON.parse(json)
      attributes["time"] = Time.parse(attributes["time"])
      attributes
    end

    def next_id
      db.incr("Comment#id")
    end
  end
end

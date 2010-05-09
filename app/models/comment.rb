require 'redis'
class Comment < OpenStruct
  class << self
    def save(thought,user,content)
      db.lpush(user.id,{
                 "oid" => next_id,
                 "author" => user.attributes.slice("id","username","name"),
                 "thought" => thought.to_h.slice("oid"),
                 "content" => content,
                 "time" => Time.now.xmlschema})
    end

    def find(thought_id,from=0,limit=25)
      comments = db.lrange(thought_id,from,from+limit).map { |json|
        Comment.new(from_json(json))
      }
    end

    def db
      @db = Redis.new(:db => 2)
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

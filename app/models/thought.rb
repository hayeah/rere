require 'redis'
class Thought < OpenStruct
  class << self
    def save(user,content)
      id = next_id
      attributes = {
        "oid" => id,
        "author" => user.attributes.slice("id","username","name"),
        "content" => content,
        "time" => Time.now.xmlschema
      }
      db.lpush(user.id,attributes.to_json)
    end

    def find(user,from=0,limit=25)
      db.lrange(user.id,from,from+limit).map { |json|
        Thought.new(from_json(json))
      }
    end

    def db
      @db ||= Redis.new(:db => 1)
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
      db.incr("Thought#id")
    end
  end

  def comments
    @comments ||= Comment.find(self.oid)
  end
end

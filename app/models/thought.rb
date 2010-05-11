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
      json = attributes.to_json
      # push to my own personal stream
      db.lpush(user.id,json)

      # push to public streams
      # to myself and all my followers
      Following.followers(user)+[user].each do |person|
        db.lpush("#{person.id}.public",json)
      end
    end

    def find(user,from=0,limit=25)
      db.lrange(user.id,from,from+limit).map { |json|
        Thought.new(from_json(json))
      }
    end

    def public(user,from=0,limit=25)
      db.lrange("#{user.id}.public",from,from+limit).map { |json|
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

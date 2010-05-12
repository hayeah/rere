module RedisDB
  extend self
  def db(n=1)
    Redis.new(:db => n)
  end

  Thought = db(1)
  Comment = db(2)
  Following = db(3)
  Group = db(4)
  GroupThought = db(5)
end

class StreamThought < ActiveRecord::Base
  belongs_to :thought
  belongs_to :from, :polymorphic => true
  belongs_to :to, :polymorphic => true
  
  class << self
    # We select distinct to remove duplicates shared thoughts. This
    # happens when the thought is shared through both a follower
    # relationship and a group membership.
    def for(to_object)
      thought_ids = StreamThought.select("distinct thought_id").
        where(:to_id => to_object.id,:to_type => to_object.class.to_s).
        order("thought_id desc").
        limit(25).
        map(&:thought_id)
      # TODO should include user as group
      Thought.where(:id => thought_ids).includes(:comments => [:user])
    end

    # when a relationship is removed, delete all the thoughts from stream
    def remove_all(from,to)
      StreamThought.where(:from_id => from.id,
                          :from_type => from.class.to_s,
                          :to_id => to.id,
                          :to_type => to.class.to_s).delete_all
    end

    # when a relationship is established, add all the thoughts into stream
    #
    # TODO uniqueness constraint on :to and :from ?
    def add_all(from,to)
      # arbitrarily limit it to the last 257 thoughts
      ## why 257? just to be more arbitrary. it's a prime. primes are
      ## good. they are good because i say so. i say so because i am
      ## arbitrary.
      from.thoughts.limit(257).each do |thought|
        share(thought,from,to)
      end
    end
  end
end

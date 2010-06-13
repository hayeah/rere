class StreamThought < ActiveRecord::Base
  belongs_to :thought
  belongs_to :from, :polymorphic => true
  belongs_to :to, :polymorphic => true
  
  class << self
    
  end
end

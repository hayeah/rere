class SharedThought < ActiveRecord::Base
  belongs_to :thought
  belongs_to :subject, :polymorphic => true
end

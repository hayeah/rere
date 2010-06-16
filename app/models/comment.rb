class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :thought

  # author of thought
  # all users that made a comment
  # but not the user that made the comment
  def participants
    User.find([self.thought.user_id,*thought.comments.map(&:user_id)].compact-[self.user_id])
  end
end

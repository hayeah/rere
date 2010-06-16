require 'spec_helper'

describe Comment do
  let(:u1) { Factory(:user) }
  let(:u2) { Factory(:user) }
  let(:u3) { Factory(:user) }
  let(:thought) { u1.share("foo") }

  context "#participants" do
    let(:comment) {
      thought.comment(u2,"foo")
    }
    
    it "includes author of the parent thought" do
      comment.participants.should include(u1)
    end

    it "includes all users that made comment" do
      thought.comment(u3,"bar")
      comment.participants.should include(u3)
    end

    it "does not include the user making the comment" do
      comment.participants.should_not include(comment.user)
    end
  end
end

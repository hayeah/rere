require 'spec_helper'

describe User do
  let(:u1) { Factory(:user) }
  let(:u2) { Factory(:user) }

  context "#watch" do
    context "watching itself" do
      it "returns nil" do
        u1.watch(u1).should be_nil
      end

      it "does not create record" do
        u1.watch(u1)
        u1.watchers.should be_empty
        u1.watched.should be_empty
      end
      
    end

    context "u1 watching u2" do
      before do
          u1.watch(u2)
      end

      specify "u1 is watching u2" do
        u1.watching?(u2).should be_true
      end
      
      specify "u1 is watching u2" do
        u1.watched.should include(u2)
      end

      specify "u2 is watched by u1" do
        u2.watchers.should include(u1)
      end

      it "raises if a user is watched twice" do
        lambda { u1.watch(u2) }.should raise_error(ActiveRecord::RecordNotUnique)
      end
    end
  end

  context "#share" do
    let(:thought) do
      u1.share("content")
      u1.thoughts.first
    end
    
    it "creates a new thought" do
      thought
      u1.should have(1).thought
    end

    it "creates new thought with content" do
      thought.content.should == "content"
    end

    context "broadcast to my watchers" do
      before do
        u2.watch(u1)
        thought
      end

      let(:shares) do
        u2.shares
      end

      it "shares thought with u2" do
        u2.shares.should include(thought)
      end

      it "shares thought with self" do
        u1.shares.should include(thought)
      end
    end
  end

end

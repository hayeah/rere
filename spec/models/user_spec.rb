require 'spec_helper'

describe User do
  let(:u1) { Factory(:user) }
  let(:u2) { Factory(:user) }

  let(:group) { Factory(:group) }

  context "username validation" do
    def user(username)
      Factory.build(:user,:username => username)
    end

    it "disallows certain keywords" do
      user("admin").should_not be_valid
      user("root").should_not be_valid
    end
  end

  context "#follow" do
    it "raises when following self" do
      lambda { u1.follow(u1) }.should raise_error(Following::NotReflexive)
    end
    
    context "u1 following u2" do
      before do
        u1.follow(u2)
      end

      specify "u1 is following u2" do
        u1.following?(u2).should be_true
      end
      
      specify "u1 is following u2" do
        u1.followed.should include(u2)
      end

      specify "u2 is followed by u1" do
        u2.followers.should include(u1)
      end

      it "raises if a user is followed twice" do
        lambda { u1.follow(u2) }.should raise_error(ActiveRecord::RecordNotUnique)
      end

      specify "followers" do
        u2.followers.should == [u1]
      end

      specify "followed" do
        u1.followed.should == [u2]
      end
    end
  end
  
  context "#share" do
    let(:thought) { u1.share("foo") }

    it "strips the content" do
      u1.share(" foo\n\n   ").content.should == "foo"
    end

    specify "content" do
      thought.content.should == "foo"
    end

    context "with no followers" do
      before { thought }
      it "doesn't appear in follower's stream" do
        u2.stream.should be_empty
      end

      it "appears in author's stream" do
        u1.stream.should == [thought]
      end
    end

    context "with a follower" do
      before {
        u2.follow u1
        thought
      }

      it "appears in follower's stream" do
        u2.stream.should == [thought]
      end

      it "appears in author's stream" do
        u1.stream.should == [thought]
      end
    end

    context "with members in a group" do
      let(:thought) { u1.share("foo",group) }
      before {
        group.join(u2)
        thought
      }

      it "appears in member's stream" do
        u2.stream.should == [thought]
      end
    end

    context "when the follower is also member in the group" do
      let(:thought){ u1.share("foo",group) }
      before {
        u2.follow u1
        group.join(u2)
        thought
      }

      it "shares via group membership" do
        StreamThought.where(:from_id => group.id,
                            :from_type => group.class.to_s,
                            :to_id => u2.id,
                            :to_type => u2.class.to_s).should_not be_empty
      end

      it "shares via follower relationship" do
        StreamThought.where(:from_id => u1.id,
                            :from_type => u1.class.to_s,
                            :to_id => u2.id,
                            :to_type => u2.class.to_s).should_not be_empty
      end

      it "appears once in member's stream" do
        u2.stream.should == [thought]
      end
    end
  end

  context "#unfollow" do
    before do
      u2.follow(u1)
      u1.share("foo")
    end
    
    it "unfollowes" do
      u1.unfollow(u2)
      u1.following?(u2).should be_false
    end

    it "removes messages of unfollowed user from follower's stream" do
      u2.stream.should_not be_empty
      u2.unfollow(u1)
      u2.stream.should be_empty
    end

    it "does nothing if unfollowing a non followed user" do
      u2.unfollow(u1)
      lambda { u2.unfollow(u1) }.should_not raise_error
    end
  end
end

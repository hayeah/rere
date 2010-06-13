require 'spec_helper'

describe Thought do
  let(:u1) { Factory(:user) }
  let(:u2) { Factory(:user) }
  let(:u3) { Factory(:user) }

  let(:group) { Factory(:group) }
  
  describe ".share" do
    let(:thought) { Thought.share("foo",u1) }

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
      let(:thought){ Thought.share("foo",u1,group) }
      before {
        group.join(u2)
        thought
      }

      it "appears in member's stream" do
        u2.stream.should == [thought]
      end
    end

    context "when the follower is also member in the group" do
      let(:thought){ Thought.share("foo",u1,group) }
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
  
end

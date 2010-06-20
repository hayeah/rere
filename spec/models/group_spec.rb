require 'spec_helper'

describe Group do
  let(:u1) { Factory(:user) }
  let(:u2) { Factory(:user) }
  let(:group) { Factory(:group) }

  
  context ".make" do
    let(:creator) { u1 }
    let(:group) {
      Group.make(:name => "test",
                 :description => "a test",
                 :creator => creator)
    }

    it "creates a record" do
      group && Group.all.should == [group]
    end

    it "sets creator of group" do
      group.creator.should == creator
    end
    
    it "adds creator to group members" do
      group.member?(u1)
    end
  end

  context "#permalink" do
    let(:group) {
      g = Group.new(:name => "123-abc_efg ")
      g.valid?
      g
    }

    it "dahserize any non-alphanumeric chars" do
      group.permalink.should == "123-abc-efg-"
    end
  end
  
  context "#join" do
    before do
      group.add(u1)
    end

    it "has a member for the group" do
      group.members.should == [u1]
    end

    it "has u1 as a member" do
      group.member?(u1).should be_true
    end

    it "raises if joined twice" do
      lambda { group.add(u1) }.should raise_error(ActiveRecord::RecordNotUnique)
    end
  end

  context "#remove" do
    before do
      group.add(u1)
      group.remove(u1)
    end

    it "has no member for the group" do
      group.members.should be_empty
    end

    it "has u1 as a member" do
      group.member?(u1).should be_false
    end

    it "does nothing if removed twice" do
      lambda { group.remove(u1) }.should_not raise_error
    end

    it "raises if group creator tries to leave the group" do
      lambda { group.remove(group.creator) }.should raise_error(Group::BadAuth)
    end
  end

  context "#share" do
    before do
      group.add(u1)
    end

    it "allows non-group member to post" do
      group.share("a",u1).should be_a(Thought)
    end

    it "does not allow non-group member to post" do
      lambda { group.share("a",u2) }.should raise_error(Group::BadAuth)
    end
  end

  context "#stream" do
    let(:thought) {
      group.share("a",u1)
    }
    before {
      group.add(u1)
      thought
    }

    it "contains thoughts" do
      group.stream.should == [thought]
    end

    context "when user unjoins a group" do
      it "does not remove thoughts already created" do
        group.remove(u1)
        group.stream.should == [thought]
      end
    end
  end
  
end

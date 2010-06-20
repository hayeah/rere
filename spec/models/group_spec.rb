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
    def permalink(name)
      g = Group.new(:name => name)
      g.set_permalink
    end

    it "strips whitespace" do
      permalink(" abc ").should == "abc"
    end
    
    it "dahserize any non-alphanumeric chars" do
      permalink("_ ;").should == "---"
    end

    it "makes permalink lowercase" do
      permalink("ABC").should == "abc"
    end

    it "keeps alphanumeric unchanged" do
      permalink("123abc").should == "123abc"
    end

    it "cannot be blank" do
      
    end

    it "sets permalink before validating" do
      g = Group.new(:name => " abc ")
      g.valid?
      g.permalink.should == "abc"
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

require 'spec_helper'

describe Group do
  let(:u1) { Factory(:user) }
  let(:u2) { Factory(:user) }
  let(:g1) { Factory(:group) }

  context ".make" do
    let(:creator) { u1 }
    let(:group) {
      Group.make(:name => "test",
                 :description => "a test",
                 :creator => creator)
    }

    it "adds creator to group members" do
      group.include?(u1)
    end
  end

  context "#join" do
    before do
      g1.join(u1)
    end

    it "has u1 as member" do
      g1.include?(u1).should be_true
    end

    it "doesn't have u1 as member" do
      g1.include?(u2).should be_false
    end
    
    it "raises when joining twice" do
      lambda { g1.join(u1) }.should raise_error(ActiveRecord::RecordNotUnique)
    end
  end
end

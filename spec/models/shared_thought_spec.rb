require 'spec_helper'

describe SharedThought do
  let(:thought) { Factory(:thought) }

  let(:user) { Factory(:user) }
  let(:shared) {
    SharedThought.create(:subject => user,
                         :thought => thought)
  }

  it "is valid" do
    shared.should be_valid
  end
  
  context "user timemline" do
    it "belongs to user as subject" do
      shared.subject.should == user
    end
  end
  
  context "group timeline" do
    let(:group) { Factory(:group)}
    let(:shared) {
      SharedThought.create(:subject => group,
                           :thought => thought)
    }

    it "belongs to user as subject" do
      shared.subject.should == group
    end
  end
end

require 'spec_helper'

describe User do
  let(:u1) { Factory(:user) }
  let(:u2) { Factory(:user) }

  context "#watch" do
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

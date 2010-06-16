require 'spec_helper'

describe Thought do
  def thought(content)
    @thought ||= Thought.new(:content => content)
  end

  let(:user) do
    Factory(:user,:username => "user")
  end

  context "#recipeint" do
    before { user }
    
    it "returns the recipient if it's mentioned at the reply to position" do
      thought("@#{user.username} something somthing").recipient.should == user
    end

    it "returns nil if user not mentioned at the reply to position" do
      thought("foo bar @#{user.username} something somthing").recipient.should be_nil
    end

    it "returns nil is user is not mentioned at all" do
      thought("fawekfj").recipient.should be_nil
    end
  end

  context "#mentions" do
    before { user }
    
    def mentions(content)
      thought(content).mentions
    end

    it "contains user" do
      mentions("@user something somthing").should == [user]
    end

    it "has no mentions" do
      mentions("foo bar").should be_empty
    end

    it "filters mentions that don't map to real users" do
      thought("@a @user @b").mentions.should == [user]
    end

    it "remove duplicate mentions" do
      thought("@user @user @user").mentions.should == [user]
    end
  end
end

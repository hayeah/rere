require 'spec_helper'

describe Thought do
  def thought(content=nil)
    user.share(content)
  end

  let(:user) do
    Factory(:user,:username => "user")
  end

  let(:user2) do
    Factory(:user,:username => "user2")
  end

  context "#recipeint" do
    before { user; user2 }
    
    it "returns the recipient if it's mentioned at the reply to position" do
      thought("@#{user2.username} something somthing").recipient.should == user2
    end

    it "returns nil if usernot mentioned at the reply to position" do
      thought("foo bar @user2 something somthing").recipient.should be_nil
    end

    it "returns nil is user is not mentioned at all" do
      thought("fawekfj").recipient.should be_nil
    end

    it "returns nil is recipient is same as author" do
      thought("@user fefo").recipient.should be_nil
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

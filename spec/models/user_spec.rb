require 'spec_helper'
#   attr_accessible :username, :email, :password, :password_confirmation

describe User do
	it "should have valid factory" do
		FactoryGirl.build(:user).should be_valid
	end
	it "should require a username" do
		User.new(:username => "").should_not be_valid
	end
end

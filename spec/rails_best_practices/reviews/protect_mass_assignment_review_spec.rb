require 'spec_helper'

describe RailsBestPractices::Reviews::ProtectMassAssignmentReview do
  let(:runner) { RailsBestPractices::Core::Runner.new(:reviews => RailsBestPractices::Reviews::ProtectMassAssignmentReview.new) }

  it "should protect mass assignment" do
    content =<<-EOF
    class User < ActiveRecord::Base
    end
    EOF
    runner.review('app/models/user.rb', content)
    runner.should have(1).errors
    runner.errors[0].to_s.should == "app/models/user.rb:1 - protect mass assignment"
  end

  it "should not protect mass assignment with attr_accessible" do
    content =<<-EOF
    class User < ActiveRecord::Base
      attr_accessible :email, :password, :password_confirmation
    end
    EOF
    runner.review('app/models/user.rb', content)
    runner.should have(0).errors
  end

  it "should not protect mass assignment with attr_protected" do
    content =<<-EOF
    class User < ActiveRecord::Base
      attr_protected :role
    end
    EOF
    runner.review('app/models/user.rb', content)
    runner.should have(0).errors
  end
end

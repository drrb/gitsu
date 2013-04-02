require 'spec_helper'

describe "git-su executable" do
    it "should run without an error" do
        output = `bin/git-su`
        $?.exitstatus.should be 0
    end
end

describe "git-whoami executable" do
    it "should run without an error" do
        output = `bin/git-whoami`
        $?.exitstatus.should be 0
    end
end

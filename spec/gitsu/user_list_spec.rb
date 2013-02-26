require 'spec_helper'
require 'yaml'

module GitSu
    describe UserList do

        let(:user_file) { "/tmp/#{rand}" }
        let(:user_list) { UserList.new(user_file) }
        after { File.delete user_file }

        describe "#add" do
            it "adds a user to the list" do
                user_list.add User.new("John Galt", "jgalt@example.com")

                user_map = YAML.parse_file(user_file).transform
                user_map.keys.should include("jgalt@example.com")
                user_map["jgalt@example.com"].should == "John Galt" 
            end
        end

        describe "#list" do
            context "when there are no users configured" do
                it "returns an empty array" do
                    user_list.list.should be_empty
                end
            end
            
            context "when there are users configured" do
                it "returns an array of all the users" do
                    user_list.add User.new("John Galt", "jgalt@example.com")

                    list = user_list.list
                    list.size.should be 1
                    list.should include User.new("John Galt", "jgalt@example.com")
                end
            end
        end

        describe "#find" do
            context "when a matching user exists" do
                it "returns the matching user by first name" do
                    user_list.add User.new("John Galt", "jgalt@example.com")

                    user_list.find("john").should == User.new("John Galt", "jgalt@example.com")
                    user_list.find("John").should == User.new("John Galt", "jgalt@example.com")
                end
                it "returns the matching user by email snippet" do
                    user_list.add User.new("John Galt", "jgalt@example.com")

                    user_list.find("example").should == User.new("John Galt", "jgalt@example.com")
                end
                it "returns the matching user by initials" do
                    user_list.add User.new("John Galt", "john.galt@example.com")

                    user_list.find("jg").should == User.new("John Galt", "john.galt@example.com")
                    user_list.find("JG").should == User.new("John Galt", "john.galt@example.com")
                end
                it "favours prefix over innards" do
                    user_list.add User.new("Matthew Jackson", "mj@example.com")
                    user_list.add User.new("Thomas Hickleton", "tom@example.com")
                    user_list.add User.new("John Smith", "js@example.com")

                    user_list.find("th").should eq User.new("Thomas Hickleton", "tom@example.com")
                    user_list.find("s").should eq User.new("John Smith", "js@example.com")
                end
                it "favours full firstname match over partial one" do
                    user_list.add User.new("Matthew Jackson", "mj@example.com")
                    user_list.add User.new("Mat Jackson", "zz@example.com")

                    user_list.find("mat").should eq User.new("Mat Jackson", "zz@example.com")
                end
            end

            context "when no matching user exists" do
                it "returns no user" do
                    user_list.find("john").should be User::NONE
                end
            end
        end
    end
end


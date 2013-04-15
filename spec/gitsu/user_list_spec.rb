require 'spec_helper'

module GitSu
    describe UserList do

        let(:user_file) { InMemoryUserFile.new }
        let(:user_list) { UserList.new(user_file) }

        describe "#add" do
            it "adds a user to the user file" do
                user = User.new("John Galt", "jgalt@example.com")
                user_list.add user
                user_file.should include user
            end
        end

        describe "#list" do
            it "reads all users from the user file" do
                user_file.stub(:read).and_return ["user1", "user2", "user3"]
                user_list.list.should == ["user1", "user2", "user3"]
            end
        end

        describe "#find" do
            context "when a matching user exists" do
                it "returns the matching user by first name" do
                    user_file.add("John Galt", "jgalt@example.com")

                    user_list.find("john").should == [User.new("John Galt", "jgalt@example.com")]
                    user_list.find("John").should == [User.new("John Galt", "jgalt@example.com")]
                end
                it "returns the matching user by email snippet" do
                    user_file.add("John Galt", "jgalt@example.com")

                    user_list.find("example").should == [User.new("John Galt", "jgalt@example.com")]
                end
                it "returns the matching user by initials" do
                    user_file.add("John Galt", "john@example.com")

                    user_list.find("jg").should == [User.new("John Galt", "john@example.com")]
                    user_list.find("JG").should == [User.new("John Galt", "john@example.com")]
                end
                it "favours prefix over innards" do
                    user_file.add("Matthew Jackson", "mj@example.com")
                    user_file.add("Thomas Hickleton", "tom@example.com")
                    user_file.add("John Smith", "js@example.com")

                    user_list.find("th").should == [User.new("Thomas Hickleton", "tom@example.com")]
                    user_list.find("s").should == [User.new("John Smith", "js@example.com")]
                end
                it "favours full firstname match over partial one" do
                    user_file.add("Matthew Jackson", "mj@example.com")
                    user_file.add("Mat Jackson", "zz@example.com")

                    user_list.find("mat").should == [User.new("Mat Jackson", "zz@example.com")]
                end
            end

            context "when no matching user exists" do
                it "raises an error" do
                    expect {user_list.find("john")}.to raise_error "No user found matching 'john'"
                end
            end

            context "when searching for two strings" do
                it "returns two users if they both match the search strings" do
                    user_file.add("Johnny A", "ja@example.com")
                    user_file.add("Johnny B", "jb@example.com")

                    user_list.find("ja", "jb").should == [
                        User.new("Johnny A", "ja@example.com"),
                        User.new("Johnny B", "jb@example.com")
                    ]
                end
                it "returns other matched users when first match already found" do
                    user_file.add("Johnny A", "ja@example.com")
                    user_file.add("Johnny B", "jb@example.com")

                    user_list.find("j", "j").should == [
                        User.new("Johnny A", "ja@example.com"),
                        User.new("Johnny B", "jb@example.com")
                    ]
                end

                context "when no matching user exists for a search term" do
                    it "raises an error" do
                        user_file.add("Johnny A", "ja@example.com")

                        expect {user_list.find("ja", "jb")}.to raise_error "No user found matching 'jb'"
                    end
                end
                context "when a search term only matches users that were already matched" do
                    it "raises an error" do
                        user_file.add("Johnny A", "ja@example.com")
                        user_file.add("Johnny B", "jb@example.com")

                        expect {user_list.find("ja", "jb", "j")}.to raise_error "No user found matching 'j' (already matched 'Johnny A <ja@example.com>' and 'Johnny B <jb@example.com>')"
                    end
                end
                context "when a search term only matches a user that was already matched, but the matching search term matched multiple users" do
                    it "adjusts the selection so that both terms match" do
                        user_file.add("Johnny A", "ja@example.com")
                        user_file.add("Johnny B", "jb@example.com")

                        user_list.find("j", "ja").sort_by{|u| u.name}.should == [
                            User.new("Johnny A", "ja@example.com"),
                            User.new("Johnny B", "jb@example.com")
                        ]
                    end
                end
            end
        end
    end

    class InMemoryUserFile
        def add(name, email)
            write User.new(name, email)
        end

        def users
            @users ||= []
        end
        
        def read
            users
        end
        
        def write(user)
            users << user
        end

        def include?(user)
            users.include? user
        end
    end
end


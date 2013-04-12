require 'spec_helper'
require 'yaml'
require 'fileutils'

module GitSu
    describe UserFile do
        let(:user_file_name) { "/tmp/#{rand}" }
        let(:user_file) { UserFile.new user_file_name }

        after do
            File.delete user_file_name if File.exist? user_file_name
        end

        describe "#initialize" do
            context "when file is missing" do
                it "creates the file" do
                    UserFile.new user_file_name
                    File.should exist user_file_name
                end
            end
            context "when file is empty" do
                it "writes a newline to the file" do
                    FileUtils.touch user_file_name
                    UserFile.new user_file_name
                    File.read(user_file_name).should == "\n"
                end
            end
            context "otherwise" do
                it "leaves the file alone" do
                    File.open(user_file_name, "w") {|f| f << "content" }
                    UserFile.new user_file_name
                    File.read(user_file_name).should == "content"
                end
            end
        end

        describe "#write" do
            it "adds a user to the user file as YAML" do
                user_file.write User.new("John Galt", "jgalt@example.com")

                user_map = YAML.load_file(user_file_name)
                user_map.should == { "jgalt@example.com" => "John Galt" }
            end
            it "doesn't overwrite existing users" do
                user_file.write User.new("John Galt", "jgalt@example.com")
                user_file.write User.new("Joseph Porter", "porter@example.com")

                user_map = YAML.load_file(user_file_name)
                user_map.should == {
                    "jgalt@example.com" => "John Galt",
                    "porter@example.com" => "Joseph Porter"
                }
            end
        end

        describe "#read" do
            it "parses user file as a list of users" do
                user_1 = User.new("John Galt", "jgalt@example.com")
                user_2 = User.new("Joseph Porter", "porter@example.com")
                user_file.write user_1 
                user_file.write user_2

                user_map = user_file.read
                user_map.sort_by {|user| user.name}.should == [ user_1, user_2 ]
            end

            context "when the file is empty" do
                it "returns an empty list" do
                    user_file.read.should == []
                end
            end
        end
    end
end


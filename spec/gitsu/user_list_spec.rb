require 'spec_helper'
require 'yaml'

module GitSu
    describe UserList do

        let(:user_file) { "/tmp/#{rand}" }
        let(:user_list) { UserList.new(user_file) }

        describe "#add" do
            it "adds a user to the list" do
                user_list.add("jgalt@example.com", "John Galt")

                user_map = YAML.parse_file(user_file).transform
                user_map.keys.should include("jgalt@example.com")
                user_map["jgalt@example.com"].should == "John Galt" 
            end
        end

        describe "#list" do
            it "provides a map of all users" do
                user_list.add("jgalt@example.com", "John Galt")

                user_list.list.keys.should include("jgalt@example.com")
                user_list.list["jgalt@example.com"].should == "John Galt" 
            end
        end
    end
end


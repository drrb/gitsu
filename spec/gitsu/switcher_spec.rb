require 'spec_helper'

module GitSu
    describe Switcher do
        let(:git) { double('git') }
        let(:user_list) { double('user_list') }
        let(:output) { double('output').as_null_object }
        let(:switcher) { Switcher.new(git, user_list, output) }

        describe '#request' do
            context "when request is a fully-qualified user string (e.g. 'John Galt <jgalt@example.com>'" do
                it "switches to user" do
                    git.should_receive(:select_user).with User.new('John Galt', 'jgalt@example.com')
                    switcher.request('John Galt <jgalt@example.com>')
                end
            end

            context "when no matching user found" do
                it "does not switch user" do
                    user_list.should_receive(:find).with('asdfasdf').and_return nil
                    switcher.request('asdfasdf')
                end
            end

            context "when user is in user list" do
                it "switches to requested user" do
                    user = User.new('John Galt', 'jgalt@example.com')

                    user_list.should_receive(:find).with("john").and_return user 
                    git.should_receive(:select_user).with user
                    switcher.request "john"
                end
            end
        end
        
        describe '#print_current' do
            context "when there is a user selected" do
                it "prints the current user" do
                    git.should_receive(:selected_user).and_return User.new('John Galt', 'jgalt@example.com')
                    output.should_receive(:puts).with("Current user: John Galt <jgalt@example.com>")
                    switcher.print_current
                end
            end

            context "when there is no user selected" do
                it "prints \"Current user: (none)\"" do
                    git.should_receive(:selected_user).and_return nil
                    output.should_receive(:puts).with("Current user: (none)")
                    switcher.print_current
                end
            end
        end

        describe '#add' do
            it "adds the specified user to the user list" do
                user_list.should_receive(:add).with User.new('John Galt', 'jgalt@example.com')
                output.should_receive(:puts).with("User 'John Galt <jgalt@example.com>' added to users")
                switcher.add("John Galt <jgalt@example.com>")
            end
        end

        describe '#list' do
            it "lists the configured users" do
                users = []
                users << "User One"
                users << "User Two"
                user_list.should_receive(:list).and_return(users)
                output.should_receive(:puts).with("User One")
                output.should_receive(:puts).with("User Two")
                switcher.list
            end
        end

        describe '#clear' do
            it "clears the current user" do
                git.should_receive(:clear_user)
                switcher.clear
            end
        end
    end
end

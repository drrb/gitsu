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
                    git.should_receive(:select_user).with(User.new('John Galt', 'jgalt@example.com'), :global)
                    switcher.request('John Galt <jgalt@example.com>', :global)
                end
            end

            context "when no matching user found" do
                it "does not switch user" do
                    user_list.should_receive(:find).with('asdfasdf').and_return nil
                    switcher.request('asdfasdf', :global)
                end
            end

            context "when user is in user list" do
                it "switches to requested user" do
                    user = User.new('John Galt', 'jgalt@example.com')

                    user_list.should_receive(:find).with("john").and_return user 
                    git.should_receive(:select_user).with user, :global
                    switcher.request "john", :global
                end
            end
        end
        
        describe '#print_current' do
            context "when a scope is specified" do
                context "when no scope is specified" do
                    it "prints all users" do
                        git.should_receive(:selected_user).with(:derived).and_return User.new('Johnny Local', 'jlocal@example.com')
                        git.should_receive(:selected_user).with(:local).and_return User.new('Johnny Local', 'jlocal@example.com')
                        git.should_receive(:selected_user).with(:global).and_return User.new('Johnny Global', 'jglobal@example.com')
                        git.should_receive(:selected_user).with(:system).and_return User.new('Johnny System', 'jsystem@example.com')
                        output.should_receive(:puts).with("Current user: Johnny Local <jlocal@example.com>")
                        output.should_receive(:puts).with("Local: Johnny Local <jlocal@example.com>")
                        output.should_receive(:puts).with("Global: Johnny Global <jglobal@example.com>")
                        output.should_receive(:puts).with("System: Johnny System <jsystem@example.com>")
                        switcher.print_current(:derived)
                    end
                end

                context "when a scope is specified" do
                    context "when there is a user selected" do
                        it "prints the current user" do
                            git.should_receive(:selected_user).with(:global).and_return User.new('John Galt', 'jgalt@example.com')
                            output.should_receive(:puts).with("Global user: John Galt <jgalt@example.com>")
                            switcher.print_current(:global)
                        end
                    end

                    context "when there is no user selected" do
                        it "prints \"Current user: (none)\"" do
                            git.should_receive(:selected_user).with(:local).and_return nil
                            output.should_receive(:puts).with("Local user: (none)")
                            switcher.print_current(:local)
                        end
                    end
                end
            end
        end

        describe '#add' do
            context "when the user doesn't already exist in the user list" do
                it "adds the specified user to the user list" do
                    user_list.should_receive(:list).and_return []
                    user_list.should_receive(:add).with User.new('John Galt', 'jgalt@example.com')
                    output.should_receive(:puts).with("User 'John Galt <jgalt@example.com>' added to users")
                    switcher.add("John Galt <jgalt@example.com>")
                end
            end
            context "when the user already exists in the user list" do
                it "Doesn't add the user to the user list" do
                    user_list.should_receive(:list).and_return [User.new('John Galt', 'jgalt@example.com')]
                    output.should_receive(:puts).with("User 'John Galt <jgalt@example.com>' already in user list")
                    switcher.add("John Galt <jgalt@example.com>")
                end
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
            context "when a scope is specified" do
                it "clears the current user in the specified scope" do
                    git.should_receive(:clear_user).with(:local)
                    switcher.clear :local
                end
            end
            context "when 'all' scope is specified" do
                it "clears all Git users" do
                    git.should_receive(:clear_user).with(:local)
                    git.should_receive(:clear_user).with(:global)
                    git.should_receive(:clear_user).with(:system)
                    switcher.clear :all
                end
            end
        end
    end
end

require 'spec_helper'

module GitSu

    describe Switcher do
        let(:git) { double('git') }
        let(:user_list) { double('user_list') }
        let(:output) { double('output').as_null_object }
        let(:switcher) { Switcher.new(git, user_list, output) }
        let(:a_user) { User.new("Johnny Bravo", "jbravo@example.com") }

        describe '#request' do
            context "when request is a fully-qualified user string (e.g. 'John Galt <jgalt@example.com>'" do
                it "switches to user" do
                    user = User.new('John Galt', 'jgalt@example.com')
                    git.should_receive(:select_user).with(user, :global)
                    git.should_receive(:render).with(user).and_return(user.to_s)
                    output.should_receive(:puts).with("Switched global user to John Galt <jgalt@example.com>")
                    switcher.request('John Galt <jgalt@example.com>', :global)
                end
            end

            context "when no matching user found" do
                it "does not switch user" do
                    user_list.should_receive(:find).with('asdfasdf').and_return User::NONE
                    output.should_receive(:puts).with("No user found matching 'asdfasdf'")
                    switcher.request('asdfasdf', :global)
                end
            end

            context "when user is in user list" do
                it "switches to requested user" do
                    user = User.new('John Galt', 'jgalt@example.com')

                    user_list.should_receive(:find).with("john").and_return user 
                    git.should_receive(:select_user).with user, :global
                    git.should_receive(:render).with(user).and_return user.to_s
                    output.should_receive(:puts).with("Switched global user to John Galt <jgalt@example.com>")
                    switcher.request "john", :global
                end
            end
        end
        
        describe '#print_current' do
            context "when 'all' scope is specified" do
                it "prints all users" do
                    local_user = User.new('Johnny Local', 'jlocal@example.com')
                    global_user = User.new('Johnny Global', 'jglobal@example.com')
                    system_user = User.new('Johnny System', 'jsystem@example.com')
                    derived_user = local_user

                    git.should_receive(:selected_user).with(:derived).and_return derived_user
                    git.should_receive(:render).with(derived_user).and_return derived_user.to_s
                    git.should_receive(:selected_user).with(:local).and_return local_user
                    git.should_receive(:render).with(local_user).and_return local_user.to_s
                    git.should_receive(:selected_user).with(:global).and_return global_user
                    git.should_receive(:render).with(global_user).and_return global_user.to_s
                    git.should_receive(:selected_user).with(:system).and_return system_user
                    git.should_receive(:render).with(system_user).and_return system_user.to_s
                    output.should_receive(:puts).with("Current user: Johnny Local <jlocal@example.com>")
                    output.should_receive(:puts).with("Local: Johnny Local <jlocal@example.com>")
                    output.should_receive(:puts).with("Global: Johnny Global <jglobal@example.com>")
                    output.should_receive(:puts).with("System: Johnny System <jsystem@example.com>")
                    switcher.print_current(:all)
                end
            end

            context "when a scope is specified" do
                context "when there is a user selected" do
                    it "prints the current user" do
                        current_user = User.new('John Galt', 'jgalt@example.com')
                        git.should_receive(:selected_user).with(:global).exactly(2).times.and_return current_user
                        git.should_receive(:render).with(current_user).and_return current_user.to_s
                        output.should_receive(:puts).with("John Galt <jgalt@example.com>")
                        switcher.print_current(:global)
                    end
                end

                context "when there is no user selected" do
                    it 'does not print anything' do
                        git.should_receive(:selected_user).with(:local).and_return User::NONE
                        switcher.print_current(:local)
                    end
                end
            end

            context "when multiple scopes are specified" do
                context "when there is a user selected in all scopes" do
                    it "prints the current user in those scopes" do
                        local_user = User.new('John Local', 'jl@example.com')
                        global_user = User.new('John Global', 'jg@example.com')
                        git.should_receive(:selected_user).with(:local).exactly(2).times.and_return local_user
                        git.should_receive(:render).with(local_user).and_return local_user.to_s
                        git.should_receive(:selected_user).with(:global).exactly(2).times.and_return global_user
                        git.should_receive(:render).with(global_user).and_return global_user.to_s
                        output.should_receive(:puts).with("John Local <jl@example.com>")
                        output.should_receive(:puts).with("John Global <jg@example.com>")
                        switcher.print_current(:local, :global)
                    end
                end

                context "when there is no user selected in one scope" do
                    it 'prints only users for scopes that have users' do
                        global_user = User.new('John Global', 'jg@example.com')
                        git.should_receive(:selected_user).with(:local).and_return User::NONE
                        git.should_receive(:selected_user).with(:global).exactly(2).times.and_return global_user
                        git.should_receive(:render).with(global_user).and_return(global_user.to_s)
                        output.should_receive(:puts).with("John Global <jg@example.com>")
                        switcher.print_current(:local, :global)
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
                it "doesn't add the user to the user list" do
                    user_list.should_receive(:list).and_return [User.new('John Galt', 'jgalt@example.com')]
                    output.should_receive(:puts).with("User 'John Galt <jgalt@example.com>' already in user list")
                    switcher.add("John Galt <jgalt@example.com>")
                end
            end
            context "when the input is not in expected format" do
                it "prints an error" do
                    output.should_receive(:puts).with("Couldn't parse 'xxx' as user (expected user in format: 'John Smith <jsmith@example.com>')")
                    switcher.add("xxx")
                end
            end
        end

        describe '#list' do
            it "lists the configured users" do
                users = []
                users << User.new("User One", "1@example.com")
                users << User.new("User Two", "2@example.com")

                user_list.should_receive(:list).and_return(users)
                git.should_receive(:render).with(users.first).and_return(users.first.to_s)
                output.should_receive(:puts).with("User One <1@example.com>")
                git.should_receive(:render).with(users.last).and_return(users.last.to_s)
                output.should_receive(:puts).with("User Two <2@example.com>")
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
            context "when multiple scopes are specified" do
                it "clears Git users in the specified scopes" do
                    output.should_receive(:puts).with("Clearing Git users in local and global scopes")
                    git.should_receive(:clear_user).with(:local)
                    git.should_receive(:clear_user).with(:global)
                    switcher.clear :local,:global
                end
            end
            context "when 'all' scope is specified" do
                it "clears all Git users" do
                    output.should_receive(:puts).with("Clearing Git users in all scopes")
                    git.should_receive(:clear_user).with(:local)
                    git.should_receive(:clear_user).with(:global)
                    git.should_receive(:clear_user).with(:system)
                    switcher.clear :all
                end
            end
        end

        describe '#edit_config' do
            it "tells Git to open the Gitsu config file in an editor" do
                git.should_receive(:edit_gitsu_config)
                switcher.edit_config
            end
        end
    end
end

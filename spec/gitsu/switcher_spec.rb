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
            context "when 'all' scope is specified" do
                it "prints all users" do
                    git.should_receive(:color_output?).and_return false
                    git.should_receive(:selected_user).with(:derived).and_return User.new('Johnny Local', 'jlocal@example.com')
                    git.should_receive(:selected_user).with(:local).and_return User.new('Johnny Local', 'jlocal@example.com')
                    git.should_receive(:selected_user).with(:global).and_return User.new('Johnny Global', 'jglobal@example.com')
                    git.should_receive(:selected_user).with(:system).and_return User.new('Johnny System', 'jsystem@example.com')
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
                        git.should_receive(:color_output?).and_return false
                        git.should_receive(:selected_user).with(:global).and_return User.new('John Galt', 'jgalt@example.com')
                        output.should_receive(:puts).with("John Galt <jgalt@example.com>")
                        switcher.print_current(:global)
                    end
                end

                context "when there is no user selected" do
                    it 'does not print anything' do
                        git.should_receive(:selected_user).with(:local).and_return nil
                        switcher.print_current(:local)
                    end
                end
            end

            context "when multiple scopes are specified" do
                context "when there is a user selected in all scopes" do
                    it "prints the current user in those scopes" do
                        git.should_receive(:color_output?).and_return false
                        git.should_receive(:selected_user).with(:local).and_return User.new('John Local', 'jl@example.com')
                        git.should_receive(:selected_user).with(:global).and_return User.new('John Global', 'jg@example.com')
                        output.should_receive(:puts).with("John Local <jl@example.com>")
                        output.should_receive(:puts).with("John Global <jg@example.com>")
                        switcher.print_current(:local, :global)
                    end
                end

                context "when there is no user selected in one scope" do
                    it 'prints only users for scopes that have users' do
                        git.should_receive(:color_output?).and_return false
                        git.should_receive(:selected_user).with(:local).and_return nil
                        git.should_receive(:selected_user).with(:global).and_return User.new('John Global', 'jg@example.com')
                        output.should_receive(:puts).with("John Global <jg@example.com>")
                        switcher.print_current(:local, :global)
                    end
                end
            end

            context "when Git says to color output" do
                context "when no scope specified" do
                    it "prints all users in color" do
                        git.should_receive(:color_output?).and_return true
                        git.should_receive(:get_color).with("blue").and_return("\e[34m")
                        git.should_receive(:get_color).with("green").and_return("\e[35m")
                        git.should_receive(:get_color).with("reset").and_return("\e[0m")
                        git.should_receive(:selected_user).with(:derived).and_return User.new('Johnny Local', 'jlocal@example.com')
                        git.should_receive(:selected_user).with(:local).and_return User.new('Johnny Local', 'jlocal@example.com')
                        git.should_receive(:selected_user).with(:global).and_return User.new('Johnny Global', 'jglobal@example.com')
                        git.should_receive(:selected_user).with(:system).and_return nil
                        output.should_receive(:puts).with("Current user: \e[34mJohnny Local\e[0m \e[35m<jlocal@example.com>\e[0m")
                        output.should_receive(:puts).with("Local: \e[34mJohnny Local\e[0m \e[35m<jlocal@example.com>\e[0m")
                        output.should_receive(:puts).with("Global: \e[34mJohnny Global\e[0m \e[35m<jglobal@example.com>\e[0m")
                        output.should_receive(:puts).with("System: \e[34m(none)\e[0m")
                        switcher.print_current(:all)
                    end
                end
                context "when no scope specified" do
                    it "prints the selected user in color" do
                        git.should_receive(:color_output?).and_return true
                        git.should_receive(:get_color).with("blue").and_return("\e[34m")
                        git.should_receive(:get_color).with("green").and_return("\e[35m")
                        git.should_receive(:get_color).with("reset").and_return("\e[0m")
                        git.should_receive(:selected_user).with(:global).and_return User.new('John Galt', 'jgalt@example.com')
                        output.should_receive(:puts).with("\e[34mJohn Galt\e[0m \e[35m<jgalt@example.com>\e[0m")
                        switcher.print_current(:global)
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
                users << User.new("User One", "1@example.com")
                users << User.new("User Two", "2@example.com")

                git.should_receive(:color_output?).and_return false
                user_list.should_receive(:list).and_return(users)
                output.should_receive(:puts).with("User One <1@example.com>")
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
                    output.should_receive(:puts).with("Clearing Git user in local and global scopes")
                    git.should_receive(:clear_user).with(:local)
                    git.should_receive(:clear_user).with(:global)
                    switcher.clear :local,:global
                end
            end
            context "when 'all' scope is specified" do
                it "clears all Git users" do
                    output.should_receive(:puts).with("Clearing Git user in all scopes")
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

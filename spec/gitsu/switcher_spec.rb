# Gitsu
# Copyright (C) 2013 drrb
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

require 'spec_helper'

module GitSu

    describe Switcher do
        let(:config_repository) { double('config_repository') }
        let(:git) { double('git') }
        let(:user_list) { double('user_list') }
        let(:output) { double('output').as_null_object }
        let(:switcher) { Switcher.new(config_repository, git, user_list, output) }

        describe '#request' do
            context "when request is a fully-qualified user string (e.g. 'John Galt <jgalt@example.com>'" do
                it "switches to user and adds them" do
                    user = User.new('John Galt', 'jgalt@example.com')
                    config_repository.should_receive(:group_email_address).and_return("dev@example.com")
                    git.should_receive(:select_user).with(user, :global)
                    git.should_receive(:render).with(user).and_return(user.to_s)
                    output.should_receive(:puts).with("Switched global user to John Galt <jgalt@example.com>")
                    user_list.should_receive(:list).and_return []
                    user_list.should_receive(:add).with(user)
                    switcher.request(:global, 'John Galt <jgalt@example.com>')
                end
            end

            context "when request is for multiple users" do
                it "combines users" do
                    combined_user = User.new('Johnny A, Johnny B and Johnny C', 'dev+a+b+c@example.com')
                    config_repository.should_receive(:group_email_address).and_return("dev@example.com")
                    git.should_receive(:select_user).with(combined_user, :global)
                    git.should_receive(:render).with(combined_user).and_return(combined_user.to_s)
                    output.should_receive(:puts).with("Switched global user to Johnny A, Johnny B and Johnny C <dev+a+b+c@example.com>")
                    
                    user_list.should_receive(:list).exactly(3).times.and_return []
                    user_list.should_receive(:add).with User.new("Johnny A", "a@example.com")
                    user_list.should_receive(:add).with User.new("Johnny B", "b@example.com")
                    user_list.should_receive(:add).with User.new("Johnny C", "c@example.com")
                    switcher.request(:global, 'Johnny C <c@example.com>', 'Johnny B <b@example.com>', 'Johnny A <a@example.com>')
                end
            end

            context "when at least one user isn't found" do
                it "does not switch user" do
                    user_list.should_receive(:find).with('john', 'xx').and_raise "No user found matching 'xx'"
                    output.should_receive(:puts).with("No user found matching 'xx'")
                    switcher.request(:global, 'john', 'xx')
                end
            end

            context "when user is in user list" do
                it "switches to requested user" do
                    user = User.new('John Galt', 'jgalt@example.com')

                    user_list.should_receive(:find).with("john").and_return [user ]
                    config_repository.should_receive(:group_email_address).and_return("dev@example.com")
                    git.should_receive(:select_user).with user, :global
                    git.should_receive(:render).with(user).and_return user.to_s
                    output.should_receive(:puts).with("Switched global user to John Galt <jgalt@example.com>")
                    switcher.request :global, "john" 
                end
            end

            context "when 'default' scope is specified" do
                it "switches user in configured default scope" do
                    user = User.new('John Galt', 'jgalt@example.com')

                    user_list.should_receive(:find).with("john").and_return [user ]
                    config_repository.should_receive(:group_email_address).and_return("dev@example.com")
                    config_repository.should_receive(:default_select_scope).and_return(:global)
                    git.should_receive(:select_user).with user, :global
                    git.should_receive(:render).with(user).and_return user.to_s
                    output.should_receive(:puts).with("Switched global user to John Galt <jgalt@example.com>")
                    switcher.request :default, "john"
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

                    git.should_receive(:render_user).with(:derived).and_return derived_user.to_s
                    git.should_receive(:render_user).with(:local).and_return local_user.to_s
                    git.should_receive(:render_user).with(:global).and_return global_user.to_s
                    git.should_receive(:render_user).with(:system).and_return system_user.to_s
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
                        git.should_receive(:selected_user).with(:global).and_return current_user
                        git.should_receive(:render_user).with(:global).and_return current_user.to_s
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
                        git.should_receive(:selected_user).with(:local).and_return local_user
                        git.should_receive(:render_user).with(:local).and_return local_user.to_s
                        git.should_receive(:selected_user).with(:global).and_return global_user
                        git.should_receive(:render_user).with(:global).and_return global_user.to_s
                        output.should_receive(:puts).with("John Local <jl@example.com>")
                        output.should_receive(:puts).with("John Global <jg@example.com>")
                        switcher.print_current(:local, :global)
                    end
                end

                context "when there is no user selected in one scope" do
                    it 'prints only users for scopes that have users' do
                        global_user = User.new('John Global', 'jg@example.com')
                        git.should_receive(:selected_user).with(:local).and_return User::NONE
                        git.should_receive(:selected_user).with(:global).and_return global_user
                        git.should_receive(:render_user).with(:global).and_return global_user.to_s
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
                    output.should_receive(:puts).with("User 'John Galt <jgalt@example.com>' already in user list (try switching to them with 'git su jg')")
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

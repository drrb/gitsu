require 'spec_helper'

module GitSu
    describe Git do
        let(:shell) { double('shell') }
        let(:git) { CachingGit.new(shell) }

        describe '#select_user' do
            it 'switches to the specified user' do
                shell.should_receive(:execute).with("git config --global user.name 'John Galt'").and_return true
                shell.should_receive(:execute).with("git config --global user.email 'jgalt@example.com'").and_return true
                git.select_user User.new("John Galt", "jgalt@example.com"), :global
            end
            it 'escapes apostrophes' do
                shell.should_receive(:execute).with("git config --global user.name 'John O'\\''Grady'").and_return true
                shell.should_receive(:execute).with("git config --global user.email 'jo@example.com'").and_return true
                git.select_user User.new("John O'Grady", "jo@example.com"), :global
            end
            it "raises an exception when can't set the name" do
                shell.should_receive(:execute).with("git config --global user.name 'John O'\\''Grady'").and_return(false)
                expect {git.select_user User.new("John O'Grady", "jo@example.com"), :global}.to raise_error(Git::ConfigSettingError)
            end
        end

        describe '#selected_user' do
            context 'when a scope is specified' do
                context 'when a user is selected' do
                    it 'returns the current user' do
                        shell.should_receive(:capture).with("git config --global user.name").and_return("John Galt")
                        shell.should_receive(:capture).with("git config --global user.email").and_return("jgalt@example.com")
                        git.selected_user(:global).should == User.new("John Galt", "jgalt@example.com")
                    end
                end

                context 'when no user is selected' do
                    it 'returns the null user' do
                        shell.should_receive(:capture).with("git config --global user.name").and_return("")
                        git.selected_user(:global).should be User::NONE
                    end
                end
            end

            context 'when "derived" scope is specified' do
                it 'returns the current user derived by git' do
                    shell.should_receive(:capture).with("git config user.name").and_return("John Galt")
                    shell.should_receive(:capture).with("git config user.email").and_return("jgalt@example.com")
                    git.selected_user(:derived).should == User.new("John Galt", "jgalt@example.com")
                end
            end

            it "caches the result" do
                shell.should_receive(:capture).with("git config user.name").and_return("John Galt")
                shell.should_receive(:capture).with("git config user.email").and_return("jgalt@example.com")
                git.selected_user(:derived).should == User.new("John Galt", "jgalt@example.com")
                git.selected_user(:derived).should == User.new("John Galt", "jgalt@example.com")
            end
        end

        describe '#edit_gitsu_config' do
            it 'opens the Gitsu config in an editor' do
                shell.should_receive(:execute).with("git config --edit --file #{File.expand_path '~/.gitsu'}")
                git.edit_gitsu_config
            end
        end

        describe '#color_output?' do
            context 'when Git says to use colorize output' do
                it 'returns true' do
                    shell.should_receive(:execute).with("git config --get-colorbool color.ui").and_return true
                    git.color_output?.should be true
                end
            end

            context 'when git says not to colorize output' do
                it 'returns true' do
                    shell.should_receive(:execute).with("git config --get-colorbool color.ui").and_return false
                    git.color_output?.should be false
                end
            end

            it "caches the result" do
                shell.should_receive(:execute).with("git config --get-colorbool color.ui").and_return false
                git.color_output?.should be false
                git.color_output?.should be false
            end
        end

        describe '#clear_user' do
            context "when there's other user config" do
                it 'clears the current user in the specified scope' do
                    shell.should_receive(:capture).with("git config --local user.name").and_return("John Smith")
                    shell.should_receive(:capture).with("git config --local user.email").and_return("js@example.com")
                    shell.should_receive(:capture).with("git config --local --unset user.name").and_return("")
                    shell.should_receive(:capture).with("git config --local --unset user.email").and_return("")
                    shell.should_receive(:capture).with("git config --local --list").and_return("ui.color=true\nuser.signingkey = something\nsomething.else")
                    git.clear_user(:local)
                end
            end
            context "when there's no other user config" do
                it 'quietly attempts to remove the user section of the config in the specified scope' do
                    shell.should_receive(:capture).with("git config --system user.name").and_return("John Smith")
                    shell.should_receive(:capture).with("git config --system user.email").and_return("js@example.com")
                    shell.should_receive(:capture).with("git config --system --unset user.name").and_return("")
                    shell.should_receive(:capture).with("git config --system --unset user.email").and_return("")
                    shell.should_receive(:capture).with("git config --system --list").and_return("")
                    shell.should_receive(:capture).with("git config --system --remove-section user 2>/dev/null").and_return("")
                    git.clear_user(:system)
                end
            end
            context "when no user is selected" do
                it "doesn't attempt to clear the user" do
                    shell.should_receive(:capture).with("git config --system user.name").and_return("")
                    git.clear_user :system
                end
            end
        end

        describe '#get_color' do
            it 'gets an ANSI escape code from Git for the specified color' do
                shell.should_receive(:capture).with("git config --get-color '' 'on blue'").and_return("xxx")
                color = git.get_color("on blue")
                color.should == "xxx"
            end
            it 'caches colors' do
                shell.should_receive(:capture).with("git config --get-color '' 'on green'").and_return("xxx")
                git.get_color("on green").should == "xxx"
                git.get_color("on green").should == "xxx"
            end
        end

        describe '#render' do
            context "when Git says to color output" do
                it "colors the user output" do
                    user = User.new('John Galt', 'jgalt@example.com')

                    git.should_receive(:color_output?).and_return true
                    git.should_receive(:get_color).with("blue").and_return "__blue__"
                    git.should_receive(:get_color).with("green").and_return "__green__"
                    git.should_receive(:get_color).with("reset").and_return "__reset__"

                    git.render(user).should == "__blue__John Galt__reset__ __green__<jgalt@example.com>__reset__"
                end
            end

            context "when Git says not to color output" do
                it "calls to_s() on the user" do
                    user = User.new('John Galt', 'jgalt@example.com')

                    git.should_receive(:color_output?).and_return false

                    git.render(user).should == user.to_s
                end
            end
        end
        
        describe "#render_user" do
            it "is equivalent to calling #render(#selected_user(scope))" do
                shell.should_receive(:capture).with("git config --local user.name").and_return("John Smith")
                shell.should_receive(:capture).with("git config --local user.email").and_return("js@example.com")
                shell.should_receive(:execute).with("git config --get-colorbool color.ui").and_return true
                shell.should_receive(:capture).with("git config --get-color '' 'blue'").and_return("*")
                shell.should_receive(:capture).with("git config --get-color '' 'green'").and_return("?")
                shell.should_receive(:capture).with("git config --get-color '' 'reset'").and_return("!")
                git.render_user(:local).should == "*John Smith! ?<js@example.com>!"
            end
        end

        describe "#default_select_scope" do
            context "when a default selecton scope is configured" do
                it "returns the configured default scope" do
                    shell.should_receive(:capture).with("git config git-su.defaultSelectScope").and_return("global")
                    git.default_select_scope.should == :global
                end
            end
            context "when no default selection scope is configured" do
                it "returns the conventional default scope (local)" do
                    shell.should_receive(:capture).with("git config git-su.defaultSelectScope").and_return("")
                    git.default_select_scope.should == :local
                end
            end
            context "when an invalid default selection scope is configured" do
                it "dies noisily" do
                    shell.should_receive(:capture).with("git config git-su.defaultSelectScope").and_return("xxxxxx")
                    expect {git.default_select_scope}.to raise_error(Git::InvalidConfigError)
                end
            end
        end

        describe "#commit" do
            it "commits a file to the repository with the specified message" do
                shell.should_receive(:execute).with("git commit file.dat --message='Committing changes'")
                git.commit("file.dat", "Committing changes")
            end
        end
    end
end

require 'spec_helper'

module GitSu
    describe Git do
        let(:shell) { double('shell') }
        let(:git) { Git.new(shell) }

        describe '#select_user' do
            it 'switches to the specified user' do
                shell.should_receive(:execute).with("git config --global user.name 'John Galt'")
                shell.should_receive(:execute).with("git config --global user.email 'jgalt@example.com'")
                git.select_user User.new("John Galt", "jgalt@example.com"), :global
            end
        end

        describe '#selected_user' do
            context 'when a scope is specified' do
                context 'when a user is selected' do
                    it 'returns the current user' do
                        shell.should_receive(:execute).with("git config --global user.name").and_return("John Galt")
                        shell.should_receive(:execute).with("git config --global user.email").and_return("jgalt@example.com")
                        git.selected_user(:global).should == User.new("John Galt", "jgalt@example.com")
                    end
                end

                context 'when no user is selected' do
                    it 'returns nil' do
                        shell.should_receive(:execute).with("git config --global user.name").and_return("")
                        git.selected_user(:global).should be nil
                    end
                end
            end

            context 'when "derived" scope is specified' do
                it 'returns the current user derived by git' do
                    shell.should_receive(:execute).with("git config user.name").and_return("John Galt")
                    shell.should_receive(:execute).with("git config user.email").and_return("jgalt@example.com")
                    git.selected_user(:derived).should == User.new("John Galt", "jgalt@example.com")
                end
            end
        end

        describe '#clear_user' do
            context "when there's other user config" do
                it 'clears the current user in the specified scope' do
                    shell.should_receive(:execute).with("git config --local --unset user.name").and_return("")
                    shell.should_receive(:execute).with("git config --local --unset user.email").and_return("")
                    shell.should_receive(:execute).with("git config --local --list").and_return("ui.color=true\nuser.signingkey = something\nsomething.else")
                    git.clear_user(:local)
                end
            end
            context "when there's no other user config" do
                it 'quietly attempts to remove the user section of the config in the specified scope' do
                    shell.should_receive(:execute).with("git config --system --unset user.name").and_return("")
                    shell.should_receive(:execute).with("git config --system --unset user.email").and_return("")
                    shell.should_receive(:execute).with("git config --system --list").and_return("")
                    shell.should_receive(:execute).with("git config --system --remove-section user 2>/dev/null").and_return("")
                    git.clear_user(:system)
                end
            end
        end
    end
end

require 'spec_helper'

module GitSu
    describe Git do
        let(:shell) { double('shell') }
        let(:git) { Git.new(shell) }

        describe '#select_user' do
            it 'switches to the specified user' do
                shell.should_receive(:execute).with("git config --global user.name 'John Galt'")
                shell.should_receive(:execute).with("git config --global user.email 'jgalt@example.com'")
                git.select_user 'John Galt <jgalt@example.com>'
            end
        end

        describe '#selected_user' do
            it 'returns the current user' do
                shell.should_receive(:execute).with("git config --global user.name").and_return("John Galt")
                shell.should_receive(:execute).with("git config --global user.email").and_return("jgalt@example.com")
                git.selected_user.should == "John Galt <jgalt@example.com>"
            end
        end
    end
end

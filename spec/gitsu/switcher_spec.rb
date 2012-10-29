require 'spec_helper'

module GitSu
    describe Switcher do
        let(:git) { double('git') }
        let(:output) { double('output').as_null_object }
        let(:switcher) { Switcher.new(git, output) }

        describe '#request' do
            it "switches to the requested user" do
                git.should_receive(:select_user).with('John Galt <jgalt@example.com>')
                switcher.request('John Galt <jgalt@example.com>')
            end
        end
        
        describe '#print_current' do
            context "when there is a user selected" do
                it "prints the current user" do
                    git.should_receive(:selected_user).and_return("John Galt <jgalt@example.com>")
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
    end
end

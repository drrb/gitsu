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
    end
end

require 'spec_helper'

module GitSu
    describe Gitsu do
        let(:output) { double('output') }
        let(:switcher) { double('switcher') }
        let(:gitsu) { GitSu::Gitsu.new(switcher, output) }

        describe '#go' do
            context 'when query string provided' do
                it 'switches to the specified user' do
                    switcher.should_receive(:request).with('Joe Bloggs')
                    gitsu.go ['Joe', 'Bloggs']
                end
            end
            
            context 'when no query provided' do
                it 'prints the current user' do
                    switcher.should_receive(:print_current)
                    gitsu.go []
                end
            end
            
            context 'when "clear" option passed' do
                context 'short option (-c)' do
                    it 'clears the user' do
                        switcher.should_receive(:clear)
                        gitsu.go ["-c"]
                    end
                end

                context 'long option (--clear)' do
                    it 'prints the current user' do
                        switcher.should_receive(:clear)
                        gitsu.go ["--clear"]
                    end
                end
            end
        end
    end
end

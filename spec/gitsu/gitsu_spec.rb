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
                        switcher.should_receive(:print_current)
                        gitsu.go ["-c"]
                    end
                end

                context 'long option (--clear)' do
                    it 'clears the user' do
                        switcher.should_receive(:clear)
                        switcher.should_receive(:print_current)
                        gitsu.go ["--clear"]
                    end
                end
            end
            
            context 'when "add" option passed' do
                context 'short option (-a)' do
                    it 'adds the specified user' do
                        switcher.should_receive(:add).with("John Galt <jgalt@example.com>")
                        switcher.should_receive(:request).with("John Galt <jgalt@example.com>")
                        gitsu.go ["-a", "John Galt <jgalt@example.com>"]
                    end
                end

                context 'long option (--add)' do
                    it 'adds the specified user' do
                        switcher.should_receive(:add).with("John Galt <jgalt@example.com>")
                        switcher.should_receive(:request).with("John Galt <jgalt@example.com>")
                        gitsu.go ["--add", "John Galt <jgalt@example.com>"]
                    end
                end
            end
        end
    end
end

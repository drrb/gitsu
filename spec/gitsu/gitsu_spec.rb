require 'spec_helper'

module GitSu
    describe Gitsu do
        let(:output) { double('output') }
        let(:switcher) { double('switcher') }
        let(:gitsu) { GitSu::Gitsu.new(switcher, output) }

        describe '#go' do
            context 'when query string provided' do
                context 'when no scope specified' do
                    it 'switches to the specified user in the default scope' do
                        switcher.should_receive(:request).with('Joe Bloggs', :global)
                        gitsu.go ['Joe', 'Bloggs']
                    end
                end

                context 'when local scope specified' do
                    it 'switches to the specified user in the default scope' do
                        switcher.should_receive(:request).with('Joe Bloggs', :local)
                        gitsu.go ['Joe', 'Bloggs', "--local"]
                    end
                end

                context 'when global scope specified' do
                    it 'switches to the specified user in the global scope' do
                        switcher.should_receive(:request).with('Joe Bloggs', :global)
                        gitsu.go ['Joe', 'Bloggs', "--global"]
                    end
                end

                context 'when system scope specified' do
                    it 'switches to the specified user in the system scope' do
                        switcher.should_receive(:request).with('Joe Bloggs', :system)
                        gitsu.go ['Joe', 'Bloggs', "--system"]
                    end
                end
            end
            
            context 'when no query provided' do
                context 'when no scope specified' do
                    it 'prints the current user derived by Git' do
                        switcher.should_receive(:print_current).with(:derived)
                        gitsu.go []
                    end
                end

                context 'when scope specified' do
                    it 'prints the current user in the specified scope' do
                        switcher.should_receive(:print_current).with(:system)
                        gitsu.go ["--system"]
                    end
                end
            end
            
            context 'when "clear" option passed' do
                context "no scope is specified" do
                    context 'short option (-c)' do
                        it 'clears all Git users' do
                            switcher.should_receive(:clear).with(:all)
                            switcher.should_receive(:print_current)
                            gitsu.go ["-c"]
                        end
                    end

                    context 'long option (--clear)' do
                        it 'clears all Git users' do
                            switcher.should_receive(:clear).with(:all)
                            switcher.should_receive(:print_current)
                            gitsu.go ["--clear"]
                        end
                    end
                end

                context 'scope is specified' do
                    it 'clears the user in that scope' do
                        switcher.should_receive(:clear).with(:local)
                        switcher.should_receive(:print_current)
                        gitsu.go ["--clear", "--local"]
                    end
                end
            end
            
            context 'when "add" option passed' do
                context 'short option (-a)' do
                    it 'adds the specified user' do
                        switcher.should_receive(:add).with("John Galt <jgalt@example.com>")
                        switcher.should_receive(:request).with("John Galt <jgalt@example.com>", :global)
                        gitsu.go ["-a", "John Galt <jgalt@example.com>"]
                    end
                end

                context 'long option (--add)' do
                    it 'adds the specified user' do
                        switcher.should_receive(:add).with("John Galt <jgalt@example.com>")
                        switcher.should_receive(:request).with("John Galt <jgalt@example.com>", :global)
                        gitsu.go ["--add", "John Galt <jgalt@example.com>"]
                    end
                end
            end

            context 'when "list" option passed' do
                context 'short option (-l)' do
                    it 'lists the users' do
                        switcher.should_receive(:list)
                        gitsu.go ["-l"]
                    end
                end

                context 'long option (--list)' do
                    it 'lists the users' do
                        switcher.should_receive(:list)
                        gitsu.go ["--list"]
                    end
                end
            end
        end
    end
end

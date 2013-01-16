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
                        switcher.should_receive(:request).with('Joe Bloggs', :local)
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

                context 'when multiple scopes specified' do
                    it 'switches to the specified user in the specified scopes' do
                        switcher.should_receive(:request).with('Joe Bloggs', :local)
                        switcher.should_receive(:request).with('Joe Bloggs', :global)
                        switcher.should_receive(:request).with('Joe Bloggs', :system)
                        gitsu.go ['Joe', 'Bloggs', "--local", "--global", "--system"]
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
                    it 'prints all users' do
                        switcher.should_receive(:print_current).with(:all)
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
                            output.should_receive(:puts).with("Clearing Git user in all scopes")
                            switcher.should_receive(:clear).with(:all)
                            gitsu.go ["-c"]
                        end
                    end

                    context 'long option (--clear)' do
                        it 'clears all Git users' do
                            output.should_receive(:puts).with("Clearing Git user in all scopes")
                            switcher.should_receive(:clear).with(:all)
                            gitsu.go ["--clear"]
                        end
                    end
                end

                context 'scope is specified' do
                    it 'clears the user in that scope' do
                        output.should_receive(:puts).with("Clearing Git user in local scope")
                        switcher.should_receive(:clear).with(:local)
                        gitsu.go ["--clear", "--local"]
                    end
                end

                context 'mulitple scopes are specified' do
                    it 'clears the user in those scopes' do
                        output.should_receive(:puts).with("Clearing Git user in local and system scopes")
                        switcher.should_receive(:clear).with(:local)
                        switcher.should_receive(:clear).with(:system)
                        gitsu.go ["--clear", "--local", "--system"]
                    end
                end
            end
            
            context 'when "add" option passed' do
                context 'short option (-a)' do
                    it 'adds the specified user' do
                        switcher.should_receive(:add).with("John Galt <jgalt@example.com>")
                        gitsu.go ["-a", "John Galt <jgalt@example.com>"]
                    end
                end

                context 'long option (--add)' do
                    it 'adds the specified user' do
                        switcher.should_receive(:add).with("John Galt <jgalt@example.com>")
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

            context 'when "edit" option passed' do
                context 'short option (-e)' do
                    it 'edits the Gitsu config file' do
                        switcher.should_receive(:edit_config)
                        gitsu.go ["-e"]
                    end
                end

                context 'long option (--edit)' do
                    it 'edits the Gitsu config file' do
                        switcher.should_receive(:edit_config)
                        gitsu.go ["--edit"]
                    end
                end
            end
        end
    end
end

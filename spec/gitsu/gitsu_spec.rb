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
                        switcher.should_receive(:request).with(:default, 'Joe Bloggs')
                        gitsu.go ['Joe Bloggs']
                    end
                end

                context 'when multiple users specified' do
                    it 'switches to all users' do
                        switcher.should_receive(:request).with(:default, 'Jimmy Baggs', 'Joe Bloggs')
                        gitsu.go ['Jimmy Baggs', 'Joe Bloggs']
                    end
                end

                context 'when local scope specified' do
                    context 'as short option (-l)' do
                        it 'switches to the specified user in the default scope' do
                            switcher.should_receive(:request).with(:local, 'Joe Bloggs')
                            gitsu.go ['Joe Bloggs', "-l"]
                        end
                    end
                    context 'as long option (--local)' do
                        it 'switches to the specified user in the default scope' do
                            switcher.should_receive(:request).with(:local, 'Joe Bloggs')
                            gitsu.go ['Joe Bloggs', "--local"]
                        end
                    end
                end

                context 'when global scope specified' do
                    context 'as short option (-g)' do
                        it 'switches to the specified user in the global scope' do
                            switcher.should_receive(:request).with(:global, 'Joe Bloggs')
                            gitsu.go ['Joe Bloggs', "-g"]
                        end
                    end
                    context 'as long option (--global)' do
                        it 'switches to the specified user in the global scope' do
                            switcher.should_receive(:request).with(:global, 'Joe Bloggs')
                            gitsu.go ['Joe Bloggs', "--global"]
                        end
                    end
                end

                context 'when system scope specified' do
                    context 'as short option (-s)' do
                        it 'switches to the specified user in the system scope' do
                            switcher.should_receive(:request).with(:system, 'Joe Bloggs')
                            gitsu.go ['Joe Bloggs', "-s"]
                        end
                    end
                    context 'as long option (--system)' do
                        it 'switches to the specified user in the system scope' do
                            switcher.should_receive(:request).with(:system, 'Joe Bloggs')
                            gitsu.go ['Joe Bloggs', "--system"]
                        end
                    end
                end

                context 'when multiple scopes specified' do
                    it 'switches to the specified user in the specified scopes' do
                        switcher.should_receive(:request).with(:local, 'Joe Bloggs')
                        switcher.should_receive(:request).with(:global, 'Joe Bloggs')
                        switcher.should_receive(:request).with(:system, 'Joe Bloggs')
                        gitsu.go ['Joe Bloggs', "--local", "--global", "--system"]
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

                context 'when multiple scopes specified' do
                    it 'prints the current user in the specified scopes' do
                        switcher.should_receive(:print_current).with(:local, :system)
                        gitsu.go ["--local", "--system"]
                    end
                end
            end
            
            context 'when "clear" option passed' do
                context "no scope is specified" do
                    context 'short option (-c)' do
                        it 'clears all Git users' do
                            switcher.should_receive(:clear).with(:all)
                            gitsu.go ["-c"]
                        end
                    end

                    context 'long option (--clear)' do
                        it 'clears all Git users' do
                            switcher.should_receive(:clear).with(:all)
                            gitsu.go ["--clear"]
                        end
                    end
                end

                context 'scope is specified' do
                    it 'clears the user in that scope' do
                        switcher.should_receive(:clear).with(:local)
                        gitsu.go ["--clear", "--local"]
                    end
                end

                context 'mulitple scopes are specified' do
                    it 'clears the user in those scopes' do
                        switcher.should_receive(:clear).with(:local, :system)
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
                context 'short option (-t)' do
                    it 'lists the users' do
                        switcher.should_receive(:list)
                        gitsu.go ["-t"]
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

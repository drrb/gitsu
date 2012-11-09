require 'optparse'

module GitSu
    class Gitsu
        def initialize(switcher, output)
            @switcher, @output = switcher, output
        end

        def go(args)
            options = {}
            optparse = OptionParser.new do |opts|
                opts.banner = "Usage: git-su [options] user"

                opts.on('-l', '--list', 'List the configured users') do
                    options[:list] = true
                end

                opts.on('-c', '--clear', 'Clear the current user') do
                    options[:clear] = true
                end

                opts.on('-a', '--add USER <EMAIL>', 'Add a user in email format (e.g. John Citizen <jcitizen@example.com>)') do |user|
                    options[:add] = user
                end

                options[:scope] = :global
                opts.on('--local', 'Change user in local scope') do
                    options[:scope] = :local
                end

                opts.on('--global', 'Change user in global scope') do
                    options[:scope] = :global
                end

                opts.on('--system', 'Change user in system scope') do
                    options[:scope] = :system
                end

                opts.on('-h', '--help', 'Show this message') do
                    options[:help] = true
                    @output.puts opts
                end
            end

            optparse.parse! args
            run(options, args)
        end

        def run(options, args)
            if options[:help]
                return
            end

            if options[:list]
                @switcher.list
                return
            end

            if options[:clear]
                #TODO: clear in scope
                @switcher.clear
            end

            if options[:add]
                @switcher.add options[:add]
            end
            
            if args.empty?
                if options[:add]
                    @switcher.request options[:add], options[:scope]
                else
                    @switcher.print_current
                end
            else
                @switcher.request(args.join(" "), options[:scope])
            end
        end
    end
end


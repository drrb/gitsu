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

                opts.on('-h', '--help', 'Show this message') do
                    options[:help] = true
                    @output.puts opts
                end
            end

            optparse.parse! args
            begin
                run(options, args)
            rescue StandardError => error
                @output.puts error
            end
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
                @switcher.clear
            end

            if options[:add]
                @switcher.add options[:add]
            end
            
            if args.empty?
                if options[:add]
                    @switcher.request options[:add]
                else
                    @switcher.print_current
                end
            else
                @switcher.request(args.join " ")
            end
        end
    end
end


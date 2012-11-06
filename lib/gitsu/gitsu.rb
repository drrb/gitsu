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

                options[:clear] = false
                opts.on('-c', '--clear', 'Clear the current user') do
                    options[:clear] = true
                end

                options[:add] = false
                opts.on('-a', '--add USER <EMAIL>', 'Add a user in email format (e.g. John Citizen <jcitizen@example.com>)') do |user|
                    options[:add] = user
                end

                options[:help] = false
                opts.on('-h', '--help', 'Show this message') do
                    options[:help] = true
                    @output.puts opts
                end
            end

            optparse.parse! args

            if options[:help]
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


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

                options[:help] = false
                opts.on('-h', '--help', 'Show this message') do
                    options[:help] = true
                    @output.puts opts
                end
            end

            optparse.parse! args

            if options[:help]

            elsif options[:clear]
                @switcher.clear
            elsif args.empty?
                @switcher.print_current
            else
                @switcher.request(args.join " ")
            end
        end
    end
end


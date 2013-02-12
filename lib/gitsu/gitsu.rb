require 'optparse'

module GitSu
    DEFAULT_CLEAR_SCOPES = [:all]
    DEFAULT_PRINT_SCOPES = [:all]
    DEFAULT_SELECT_SCOPES = [:local]

    class Gitsu

        def initialize(switcher, output)
            @switcher, @output = switcher, output
        end

        def go(args)
            options = {}
            optparse = OptionParser.new do |opts|
                opts.banner = "Usage: git-su [options] user"

                opts.on('-t', '--list', 'List the configured users') do
                    options[:list] = true
                end

                opts.on('-c', '--clear', 'Clear the current user') do
                    options[:clear] = true
                end

                opts.on('-a', '--add USER <EMAIL>', 'Add a user in email format (e.g. John Citizen <jcitizen@example.com>)') do |user|
                    options[:add] = user
                end

                opts.on('-e', '--edit', 'Open the Gitsu config file in an editor') do
                    options[:edit] = true
                end

                options[:scope] = []
                opts.on('-l', '--local', 'Change user in local scope') do
                    options[:scope] << :local
                end

                opts.on('-g', '--global', 'Change user in global scope') do
                    options[:scope] << :global
                end

                opts.on('-s', '--system', 'Change user in system scope') do
                    options[:scope] << :system
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

            if options[:edit]
                @switcher.edit_config
                return
            end

            scopes = options[:scope]

            if options[:clear]
                clear_scopes = scopes.empty? ? DEFAULT_CLEAR_SCOPES : scopes
                @switcher.clear *clear_scopes
            end

            if options[:add]
                @switcher.add options[:add]
            end
            
            if args.empty?
                unless options[:add] || options [:clear]
                    print_scopes = scopes.empty? ? DEFAULT_PRINT_SCOPES : scopes
                    @switcher.print_current *print_scopes
                end
            else
                select_scopes = scopes.empty? ? DEFAULT_SELECT_SCOPES : scopes
                select_scopes.each do |scope|
                    @switcher.request(args.join(" "), scope)
                end
            end
        end
    end
end


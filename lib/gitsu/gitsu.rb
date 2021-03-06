# Gitsu
# Copyright (C) 2014 drrb
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

require 'optparse'

module GitSu
    class Gitsu

        def initialize(switcher, output)
            @switcher, @output = switcher, output
        end

        def go(args)
            options = {}
            optparse = OptionParser.new do |opts|
                opts.version = GitSu::VERSION
                opts.banner = <<-BANNER
Gitsu Copyright (C) 2013  drrb
This program comes with ABSOLUTELY NO WARRANTY.
This is free software, and you are welcome to redistribute it under
certain conditions; see <http://www.gnu.org/licenses/> for details.

Usage: git-su [options] user
                BANNER

                opts.on('-t', '--list', 'List the configured users') do
                    options[:list] = true
                end

                opts.on('-c', '--clear', 'Clear the current user') do
                    options[:clear] = true
                end

                opts.on('-a', '--add USER', 'Add a user in email format (e.g. John Citizen <jcitizen@example.com>)') do |user|
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

        private
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
                clear_scopes = scopes.empty? ? [:all] : scopes
                @switcher.clear *clear_scopes
            end

            if options[:add]
                @switcher.add options[:add]
            end
            
            if args.empty?
                unless options[:add] || options [:clear]
                    print_scopes = scopes.empty? ? [:all] : scopes
                    @switcher.print_current *print_scopes
                end
            else
                select_scopes = scopes.empty? ? [:default] : scopes
                select_scopes.each do |scope|
                    @switcher.request(scope, *args)
                end
            end
        end
    end
end


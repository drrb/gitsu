require 'gitsu/array'

module GitSu
    class Switcher
        def initialize(git, user_list, output)
            @git, @user_list, @output = git, user_list, output
        end

        def request(scope, *user_strings)
            begin
                found_users = find_all user_strings
                found_user = combine_all found_users
                scope = scope == :default ? @git.default_select_scope : scope
                @git.select_user(found_user, scope)
                @output.puts "Switched #{scope} user to #{@git.render found_user}"
            rescue RuntimeError => error
                @output.puts error.message
            end
        end
        
        def print_current(*scopes)
            if scopes.include? :all
                @output.puts "Current user: #{@git.render_user(:derived)}"
                @output.puts
                @output.puts "Local: #{@git.render_user(:local)}"
                @output.puts "Global: #{@git.render_user(:global)}"
                @output.puts "System: #{@git.render_user(:system)}"
            else
                scopes.each do |scope|
                    unless @git.selected_user(scope).none?
                        @output.puts @git.render_user(scope)
                    end
                end
            end
        end

        def edit_config
            @git.edit_gitsu_config
        end

        def clear(*scopes)
            scope_list = scopes.list

            if scopes.include? :all
                scopes = [:local, :global, :system]
            end

            @output.puts "Clearing Git #{scopes.pluralize('user')} in #{scope_list} #{scopes.pluralize('scope')}"
            scopes.each do |scope|
                @git.clear_user(scope)
            end
        end

        def list
            @user_list.list.each do |user|
                @output.puts @git.render(user)
            end
        end

        def add(user_string)
            begin
                user = User.parse(user_string)
            rescue User::ParseError => parse_error
                @output.puts parse_error.message
                return
            end
            if @user_list.list.include? user
                @output.puts "User '#{user}' already in user list"
            else
                @user_list.add user
                @output.puts "User '#{user}' added to users"
            end
        end

        private
        def find_all(user_strings)
            user_strings.map do |user_string|
                found_user = find user_string
                if found_user.none?
                    raise "No user found matching '#{user_string}'"
                else
                    found_user
                end
            end
        end

        def find(user_string)
            begin
                User.parse(user_string)
            rescue User::ParseError => parse_error
                @user_list.find(user_string)
            end
        end

        def combine_all(users)
            users.inject(User::NONE) do |combined_user, user|
                combined_user.combine user
            end
        end
    end
end

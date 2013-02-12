class Array
    def list
        if empty?
            ""
        elsif size == 1
            last.to_s
        else
            map{|e| e.to_s}.slice(0, length - 1).join(", ") + " and " + last.to_s
        end
    end

    def pluralize(word)
        size > 1 ? word + "s" : word
    end
end

module GitSu

    class Switcher
        def initialize(git, user_list, output)
            @git, @user_list, @output = git, user_list, output
        end

        def request(user, scope)
            begin
                matching_user = User.parse(user)
            rescue User::ParseError => parse_error
                matching_user = @user_list.find(user)
            end

            if matching_user.none?
                @output.puts "No user found matching '#{user}'"
            else
                @git.select_user(matching_user, scope)
                @output.puts "Switched #{scope} user to #{@git.render matching_user}"
            end
        end
        
        def print_current(*scopes)
            if scopes.include? :all
                @output.puts "Current user: #{render_user(:derived)}"
                @output.puts
                @output.puts "Local: #{render_user(:local)}"
                @output.puts "Global: #{render_user(:global)}"
                @output.puts "System: #{render_user(:system)}"
            else
                scopes.each do |scope|
                    unless @git.selected_user(scope).none?
                        @output.puts render_user(scope)
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

        def render_user(scope)
            @git.render @git.selected_user(scope)
        end
    end
end

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
end

module GitSu
    class Switcher
        def initialize(git, user_list, output)
            @git, @user_list, @output = git, user_list, output
        end

        def request(user, scope)
            if user =~ /[^<]+ <.+@.+>/
                matching_user = User.parse(user)
            else
                matching_user = @user_list.find user
            end
            if matching_user
                @git.select_user(matching_user, scope)
                @output.puts "Switched #{scope} user to #{matching_user}"
            else
                @output.puts "No user found matching '#{user}'"
            end
        end

        def get_user(scope, suppress_none = false)
            selected_user = @git.selected_user(scope)
            if selected_user.nil? && suppress_none
                ""
            else
                user = selected_user.nil? ? "(none)" : selected_user
                maybe_color user
            end
        end

        def maybe_color(user)
            if color_output?
                user_color = get_color "blue"
                email_color = get_color "green"
                reset_color = get_color "reset"
                if user.instance_of? String
                    user_color + user + reset_color
                else
                    user.to_ansi_s(user_color, email_color, reset_color)
                end
            else
                user.to_s
            end
        end

        def get_color(color_name)
            @colors ||= {}
            #TODO: what if it's an invalid color?
            @colors[color_name] ||= @git.get_color color_name
        end

        def color_output?
            @color_output.nil? ? @color_output = @git.color_output? : @color_output
        end
        
        def print_current(scope)
            if scope == :all
                @output.puts "Current user: #{get_user(:derived)}"
                @output.puts
                @output.puts "Local: #{get_user(:local)}"
                @output.puts "Global: #{get_user(:global)}"
                @output.puts "System: #{get_user(:system)}"
            else
                @output.puts get_user(scope, true)
            end
        end

        def edit_config
            @git.edit_gitsu_config
        end

        def clear(*scopes)
            scope_word = scopes.include?(:all) || scopes.size > 1 ? "scopes" : "scope"
            @output.puts "Clearing Git user in #{scopes.list} #{scope_word}"
            if scopes.include? :all
                @git.clear_user(:local)
                @git.clear_user(:global)
                @git.clear_user(:system)
            else
                scopes.each do |scope|
                    @git.clear_user(scope)
                end
            end
        end

        def list
            @user_list.list.each do |user|
                @output.puts maybe_color user
            end
        end

        def add(user_string)
            user = User.parse user_string
            if @user_list.list.include? user
                @output.puts "User '#{user}' already in user list"
            else
                @user_list.add user
                @output.puts "User '#{user}' added to users"
            end
        end
    end
end

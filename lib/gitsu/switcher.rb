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
                @output.puts "Switched to user #{matching_user}"
            else
                @output.puts "No user found matching '#{user}'"
            end
        end

        def get_user(scope)
            @git.selected_user(scope) || "(none)"
        end
        
        def print_current(scope)
            if scope == :derived
                @output.puts "Current user: #{get_user(scope)}"
                @output.puts
                @output.puts "Local: #{get_user(:local)}"
                @output.puts "Global: #{get_user(:global)}"
                @output.puts "System: #{get_user(:system)}"
            else
                @output.puts "#{scope.capitalize} user: #{get_user(scope)}"
            end
        end

        def clear(scope)
            @git.clear_user(scope)
        end
        
        def list
            @user_list.list.each do |user|
                @output.puts user
            end
        end

        def add(user)
            @user_list.add User.parse(user)
            @output.puts "User '#{user}' added to users"
        end
    end
end

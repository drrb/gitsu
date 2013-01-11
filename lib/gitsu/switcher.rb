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

        def get_user(scope)
            @git.selected_user(scope) || "(none)"
        end
        
        def print_current(scope)
            if scope == :all
                @output.puts "Current user: #{get_user(:derived)}"
                @output.puts
                @output.puts "Local: #{get_user(:local)}"
                @output.puts "Global: #{get_user(:global)}"
                @output.puts "System: #{get_user(:system)}"
            else
                @output.puts "#{scope.capitalize} user: #{get_user(scope)}"
            end
        end

        def clear(scope)
            if scope == :all
                @git.clear_user(:local)
                @git.clear_user(:global)
                @git.clear_user(:system)
            else
                @git.clear_user(scope)
            end
        end
        
        def list
            @user_list.list.each do |user|
                @output.puts user
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

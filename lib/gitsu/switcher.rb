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
        
        def print_current
            user = @git.selected_user(:global)
            if user.nil?
                @output.puts "Current user: (none)"
            else
                @output.puts "Current user: #{user}"
            end
        end

        def clear
            @git.clear_user
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

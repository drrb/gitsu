module GitSu
    class Switcher
        def initialize(git, user_list, output)
            @git, @user_list, @output = git, user_list, output
        end

        def request(user)
            matching_user = @user_list.find user
            if matching_user
                @git.select_user matching_user
                @output.puts "Switched to user #{matching_user}"
            else
                @output.puts "No user found matching '#{user}'"
            end
        end
        
        def print_current
            user = @git.selected_user
            if user.nil?
                @output.puts "Current user: (none)"
            else
                @output.puts "Current user: #{user}"
            end
        end

        def clear
            @git.clear_user
        end
    end
end

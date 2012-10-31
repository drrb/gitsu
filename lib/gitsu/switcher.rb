module GitSu
    class Switcher
        def initialize(git, user_list, output)
            @git, @user_list, @output = git, user_list, output
        end

        def request(user)
            matching_user = @user_list.find user
            user = matching_user ? matching_user : user
            @git.select_user user
            @output.puts "Switched to user #{user}"
        end
        
        def print_current
            user = @git.selected_user
            if user.nil?
                @output.puts "Current user: (none)"
            else
                @output.puts "Current user: #{user}"
            end
        end
    end
end

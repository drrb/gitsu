module GitSu
    class Switcher
        def initialize(git, user_list, output)
            @git, @user_list, @output = git, user_list, output
        end

        def request(user)
            matching_users = @user_list.list.select { |email,name| name.downcase.include? user }
            unless matching_users.empty?
                matching_user = matching_users.find {true}
                user = "#{matching_user[1]} <#{matching_user[0]}>"
            end
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

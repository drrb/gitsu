module GitSu
    class Switcher
        def initialize(git, output)
            @git, @output = git, output
        end

        def request(user)
            @git.select_user user
            @output.puts "Switched to user #{user}"
        end
    end
end

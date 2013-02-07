module GitSu
    class Factory
        def initialize(output)
            @output = output
        end

        def switcher
            user_list_file = File.expand_path("~/.gitsu")
            shell = Shell.new
            git = Git.new(shell)
            user_list = UserList.new(user_list_file)
            Switcher.new(git, user_list, @output)
        end

        def git_su
            Gitsu.new(switcher, @output)
        end

        def runner
            Runner.new(@output)
        end
    end
end

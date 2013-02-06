module GitSu
    class Factory
        def Factory.switcher(output)
            user_list_file = File.expand_path("~/.gitsu")
            shell = Shell.new
            git = Git.new(shell)
            user_list = UserList.new(user_list_file)
            switcher = Switcher.new(git, user_list, output)
        end

        def Factory.git_su(output)
            switcher = switcher(output)
            git_su = Gitsu.new(switcher, output)
        end
    end
end

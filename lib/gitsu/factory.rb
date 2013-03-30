module GitSu
    class Factory
        attr_accessor :git
        def initialize(output, user_list_file)
            @output, @user_list_file = output, File.expand_path(user_list_file)
        end

        def git
            @git ||= CachingGit.new(Shell.new)
        end

        def user_list
            @user_list ||= UserList.new(@user_list_file)
        end

        def switcher
            @switcher ||= Switcher.new(git, user_list, @output)
        end

        def gitsu
            @gitsu ||= Gitsu.new(switcher, @output)
        end

        def runner
            Runner.new(@output)
        end
    end
end

module GitSu
    class Git
        def initialize(shell)
            @shell = shell
        end

        def select_user(user)
            @shell.execute "git config --global user.name '#{user.name}'"
            @shell.execute "git config --global user.email '#{user.email}'"
        end

        def selected_user
            name = @shell.execute "git config --global user.name"
            if name.empty?
                nil
            else
                email = @shell.execute "git config --global user.email"
                User.new(name, email)
            end
        end

        def clear_user
            @shell.execute "git config --unset --global user.name"
            @shell.execute "git config --unset --global user.email"
            if @shell.execute("git config --list --global").chomp.split("\n").select { |e| e =~ /^user\./ }.empty?
                @shell.execute("git config --remove-section --global user")
            end
        end
    end
end

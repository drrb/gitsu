module GitSu
    class Git
        def initialize(shell)
            @shell = shell
        end

        def config_command(scope, suffix)
            if scope == :derived
                "git config "
            else
                "git config --#{scope} "
            end << suffix
        end

        def select_user(user, scope)
            @shell.execute config_command(scope, "user.name '#{user.name}'")
            @shell.execute config_command(scope, "user.email '#{user.email}'")
        end

        def selected_user(scope)
            name = @shell.execute config_command(scope, "user.name")
            if name.empty?
                nil
            else
                email = @shell.execute config_command(scope, "user.email")
                User.new(name, email)
            end
        end

        def clear_user(scope)
            @shell.execute config_command(scope, "--unset user.name")
            @shell.execute config_command(scope, "--unset user.email")
            if @shell.execute(config_command(scope, "--list")).chomp.split("\n").select { |e| e =~ /^user\./ }.empty?
                @shell.execute config_command(scope, "--remove-section user")
            end
        end
    end
end

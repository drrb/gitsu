module GitSu
    class Git
        def initialize(shell)
            @shell = shell
        end

        def config_command(scope, suffix)
            command = "git config "
            unless scope == :derived
                command << "--#{scope} "
            end 
            command << suffix
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
                @shell.execute config_command(scope, "--remove-section user 2>/dev/null")
            end
        end
    end
end

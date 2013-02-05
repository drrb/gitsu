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

        def get_color(color_name)
            @shell.execute config_command(:derived, "--get-color '' '#{color_name}'")
        end

        def select_user(user, scope)
            # replace <'> with <'\''>. E.g. O'Grady -> O'\''Grady
            escaped_user_name = user.name.gsub(/'/, "'\\\\\''")
            @shell.execute config_command(scope, "user.name '#{escaped_user_name}'")
            @shell.execute config_command(scope, "user.email '#{user.email}'")
        end

        def selected_user(scope)
            name = @shell.execute config_command(scope, "user.name")
            if name.empty?
                User::NONE
            else
                email = @shell.execute config_command(scope, "user.email")
                User.new(name, email)
            end
        end

        def edit_gitsu_config
            @shell.delegate config_command(:derived, "--edit --file #{File.expand_path '~/.gitsu'}")
        end

        def clear_user(scope)
            @shell.execute config_command(scope, "--unset user.name")
            @shell.execute config_command(scope, "--unset user.email")
            if @shell.execute(config_command(scope, "--list")).chomp.split("\n").select { |e| e =~ /^user\./ }.empty?
                @shell.execute config_command(scope, "--remove-section user 2>/dev/null")
            end
        end

        def color_output?
            @shell.delegate config_command(:derived, "--get-colorbool color.ui")
        end
    end
end

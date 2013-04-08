module GitSu
    class Git
        class InvalidConfigError < RuntimeError
        end

        class ConfigSettingError < RuntimeError
        end

        def initialize(shell)
            @shell = shell
        end

        def get_config(scope, key)
            capture_config_command(scope, key)
        end

        def set_config(scope, key, value)
            # replace <'> with <'\''>. E.g. O'Grady -> O'\''Grady
            escaped_value = value.gsub(/'/, "'\\\\\''")
            execute_config_command(scope, "#{key} '#{escaped_value}'")
        end

        def unset_config(scope, key)
            capture_config_command(scope, "--unset #{key}")
        end

        def list_config(scope)
            capture_config_command(scope, "--list").chomp.split("\n")
        end

        def remove_config_section(scope, section)
            capture_config_command(scope, "--remove-section #{section} 2>/dev/null")
        end

        def get_color(color_name)
            capture_config_command(:derived, "--get-color '' '#{color_name}'")
        end

        def select_user(user, scope)
            set_config(scope, "user.name", user.name) or raise ConfigSettingError, "Couldn't update user config in '#{scope}' scope"
            set_config(scope, "user.email", user.email)
        end

        def selected_user(scope)
            name = get_config(scope, "user.name")
            if name.empty?
                User::NONE
            else
                email = get_config(scope, "user.email")
                User.new(name, email)
            end
        end

        def edit_gitsu_config
            execute_config_command(:derived, "--edit --file #{File.expand_path '~/.gitsu'}")
        end

        def clear_user(scope)
            unset_config(scope, "user.name")
            unset_config(scope, "user.email")
            if list_config(scope).select { |e| e =~ /^user\./ }.empty?
                remove_config_section(scope, "user")
            end
        end

        def color_output?
            execute_config_command(:derived, "--get-colorbool color.ui")
        end

        def group_email_address
            scope_string = get_config(:derived, "git-su.groupEmailAddress")
            if scope_string.empty?
                "dev@example.com"
            else
                scope_string
            end
        end

        def default_select_scope
            scope_string = get_config(:derived, "git-su.defaultSelectScope")
            if scope_string.empty?
                :local
            elsif scope_string =~ /^(local|global|system)$/
                scope_string.to_sym
            else
                raise InvalidConfigError, "Invalid configuration value found for git-su.defaultSelectScope: '#{scope_string}'. Expected one of 'local', 'global', or 'system'."
            end
        end

        def render(user)
            if color_output?
                user_color = get_color "blue"
                email_color = get_color "green"
                reset_color = get_color "reset"
                user.to_ansi_s(user_color, email_color, reset_color)
            else
                user.to_s
            end
        end

        def render_user(scope)
            render selected_user(scope)
        end

        def commit(file, message)
            @shell.execute("git commit #{file} --message='#{message}'")
        end

        private
        def config_command(scope, suffix)
            command = "git config "
            unless scope == :derived
                command << "--#{scope} "
            end 
            command << suffix
        end

        def execute_config_command(scope, command)
            @shell.execute config_command(scope, command)
        end

        def capture_config_command(scope, command)
            @shell.capture config_command(scope, command)
        end
    end

    class CachingGit < Git
        def get_color(color_name)
            @colors ||= {}
            #TODO: what if it's an invalid color?
            @colors[color_name] ||= super
        end

        def color_output?
            @color_output.nil? ? @color_output = super : @color_output
        end

        def clear_user(scope)
            # Git complains if you try to clear the user when the config file is missing
            super unless selected_user(scope).none?
        end

        def selected_user(scope)
            @selected_users ||= {}
            @selected_users[scope] ||= super
        end
    end
end

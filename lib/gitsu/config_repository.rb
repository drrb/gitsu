module GitSu
    class ConfigRepository
        class InvalidConfigError < RuntimeError
        end

        def initialize(git)
            @git = git
        end

        def get(key)
            @git.get_config(:derived, key) 
        end

        def default_select_scope
            scope_string = get("git-su.defaultSelectScope")
            if scope_string.empty?
                :local
            elsif scope_string =~ /^(local|global|system)$/
                scope_string.to_sym
            else
                raise InvalidConfigError, "Invalid configuration value found for git-su.defaultSelectScope: '#{scope_string}'. Expected one of 'local', 'global', or 'system'."
            end
        end

        def group_email_address
            scope_string = get("git-su.groupEmailAddress")
            if scope_string.empty?
                "dev@example.com"
            else
                scope_string
            end
        end
    end
end

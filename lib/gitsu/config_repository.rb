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
            scope_string = get_gitsu_config "defaultSelectScope", "local"
            if scope_string =~ /^(local|global|system)$/
                scope_string.to_sym
            else
                raise InvalidConfigError, "Invalid configuration value found for gitsu.defaultSelectScope: '#{scope_string}'. Expected one of 'local', 'global', or 'system'."
            end
        end

        def group_email_address
            get_gitsu_config  "groupEmailAddress", "dev@example.com"
        end

        private
        def get_gitsu_config(key, default)
            value = get "gitsu.#{key}"
            value.empty? ? default : value
        end
    end
end

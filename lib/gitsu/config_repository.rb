# Gitsu
# Copyright (C) 2013 drrb
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

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

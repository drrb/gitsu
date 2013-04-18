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
    class Factory
        def initialize(output, user_list_file)
            @output, @user_list_file = output, File.expand_path(user_list_file)
        end

        def git
            @git ||= CachingGit.new(Shell.new)
        end

        def config_repository
            @config_repository ||= ConfigRepository.new(git)
        end

        def user_list
            @user_list ||= UserList.new(user_file)
        end

        def user_file
            UserFile.new(@user_list_file)
        end

        def switcher
            @switcher ||= Switcher.new(config_repository, git, user_list, @output)
        end

        def gitsu
            @gitsu ||= Gitsu.new(switcher, @output)
        end

        def runner
            Runner.new(@output)
        end
    end
end

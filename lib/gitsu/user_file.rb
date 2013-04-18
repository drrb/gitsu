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

require 'fileutils'
require 'yaml'

module GitSu
    class UserFile
        def initialize(file_name)
            @file = file_name
            unless File.exist? file_name
                FileUtils.touch file_name
            end
            if File.size(file_name) == 0
                File.open(file_name, "w") do |file|
                    file << "\n"
                end
            end
        end

        def write(user)
            File.open(@file, "a") do |file|
                file.write "\n#{user.email} : #{user.name}"
            end
        end

        def read
            user_map = YAML.load_file(@file) or return []
            user_map.map do |email, name|
                User.new(name, email)
            end
        end
    end
end


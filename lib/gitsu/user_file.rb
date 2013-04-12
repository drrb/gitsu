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


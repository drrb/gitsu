require 'fileutils'
require 'yaml'

module GitSu
    class UserList
        def initialize(file)
            @file = file
            unless File.exist? file
                FileUtils.touch file
            end
        end

        def add(email, name)
            File.open(@file, "a") do |file|
                file.write "#{email} : #{name}"
            end
        end

        def list
            yaml_list = YAML.parse_file(@file)
            yaml_list ? yaml_list.transform : {}
        end
    end
end


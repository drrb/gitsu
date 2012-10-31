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

        def find(search_term)
            yaml_list = YAML.parse_file(@file)
            users = yaml_list ? yaml_list.transform : {}
            matching_users = users.select { |email,name| (name + email).downcase.include? search_term }
            if matching_users.empty?
                nil
            else
                matching_user = matching_users.find {true}
                "#{matching_user[1]} <#{matching_user[0]}>"
            end
        end
    end
end


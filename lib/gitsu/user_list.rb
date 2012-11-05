require 'fileutils'
require 'yaml'

module GitSu
    class UserList
        def initialize(file)
            @file = file
            unless File.exist? file
                FileUtils.touch file
            end
            if File.size(file) == 0
                File.write(file, "\n")
            end
        end

        def add(email, name)
            File.open(@file, "a") do |file|
                file.write "#{email} : #{name}"
            end
        end

        def find(search_term)
            if search_term =~ /[^<]+ <.+@.+>/
                return search_term
            end
            File.open("tmpfile", "w") do |f|
                f.write @file
            end
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


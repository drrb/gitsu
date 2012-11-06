require 'fileutils'
require 'yaml'

module GitSu
    class UserList
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

        def add(email, name)
            File.open(@file, "a") do |file|
                file.write "#{email} : #{name}"
            end
        end

        def find(search_term)
            if search_term =~ /[^<]+ <.+@.+>/
                return search_term
            end
            yaml_list = YAML.load_file(@file) or return nil
            users = yaml_list.map do |email, name|
                User.new(name, email)
            end
            matching_users = users.select do |user|
                ("#{user.name} #{user.email}").downcase.include? search_term 
            end
            matching_users += users.select do |user|
                user.name.split(" ").map { |word| word.chars.first }.join.downcase.include? search_term
            end

            if matching_users.empty?
                nil
            else
                matching_user = matching_users.find {true}
                "#{matching_user.name} <#{matching_user.email}>"
            end
        end
    end
end


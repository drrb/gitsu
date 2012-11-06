module GitSu
    class UserList
        def initialize(file_name)
            @user_file = UserFile.new(file_name) 
        end

        def add(email, name)
            @user_file.write(User.new(name, email))
        end

        def find(search_term)
            if search_term =~ /[^<]+ <.+@.+>/
                return search_term
            end
            users = @user_file.read
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


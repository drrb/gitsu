module GitSu
    class UserList
        def initialize(file_name)
            @user_file = UserFile.new(file_name) 
        end

        def add(user)
            @user_file.write(user)
        end

        def list
            @user_file.read
        end

        def find(search_term)
            users = @user_file.read
            matching_users = []
            matching_users += users.select do |user|
                user.name =~ /\b#{search_term}\b/i
            end
            matching_users += users.select do |user|
                user.name =~ /\b#{search_term}/i
            end
            matching_users += users.select do |user|
                user.name.split(" ").map { |word| word.chars.first }.join.downcase.include? search_term.downcase
            end
            matching_users += users.select do |user|
                ("#{user.name} #{user.email}").downcase.include? search_term.downcase
            end

            matching_users.first || User::NONE
        end
    end
end


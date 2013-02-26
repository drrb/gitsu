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
            match_strategies.each do |strategy|
                matching_users += users.select { |user| strategy.call(search_term, user) }
            end
            matching_users.first || User::NONE
        end

        def match_strategies
            [
            # Whole word of name
            lambda { |search_term, user| user.name =~ /\b#{search_term}\b/i },

            # Beginning of word in name
            lambda { |search_term, user| user.name =~ /\b#{search_term}/i },

            # Initials
            lambda do |search_term, user|
                initials = user.name.downcase.split(" ").map { |word| word.chars.first }.join
                initials.include? search_term.downcase
            end,

            # Segment anywhere in name or email
            lambda do |search_term, user|
                name_and_email = "#{user.name} #{user.email}".downcase
                name_and_email.include? search_term.downcase
            end
            ]
        end
    end
end


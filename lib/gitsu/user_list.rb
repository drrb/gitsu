module GitSu
    class UserList
        def initialize(user_file)
            @user_file = user_file
        end

        def add(user)
            @user_file.write(user)
        end

        def list
            @user_file.read
        end

        def find(*search_terms)
            found_users_per_search = find_all(search_terms)
            results = search_terms.zip(found_users_per_search).map do |search_term, matches|
                ResultSet.new(search_term, matches)
            end
            allocate_search_terms_to_names results
        end

        private
        def find_all(search_terms)
            users = list
            found_users_per_search = []
            search_terms.each do |search_term|
                matching_users = []
                match_strategies.each do |strategy|
                    matching_users += users.select { |user| strategy.call(search_term, user) }
                end
                found_users_per_search << matching_users.uniq
            end
            found_users_per_search
        end

        class ResultSet
            attr_accessor :search_term, :matches
            def initialize(search_term, matches)
                @search_term, @matches = search_term, matches
            end
        end

        def allocate_search_terms_to_names(results)
            find_unique_combination(results) or find_users_the_simple_way(results)
        end

        def find_unique_combination(results)
            results = results.clone
            # Generate all combinations
            combinations = [[]]
            results.each do |result_set|
                previous_combos = combinations.clone
                combinations = []
                previous_combos.each do |combo|
                    result_set.matches.each do |match|
                        combo_extension = combo.clone
                        combo_extension << match
                        combinations << combo_extension
                    end
                end
            end
            combinations.find do |combo|
                combo.uniq.size == combo.size
            end
        end

        def find_users_the_simple_way(results)
            matched_users = []
            results.each do |result|
                match = result.matches.find {|u| ! matched_users.include? u }
                unless match
                    if result.matches.empty?
                        raise "No user found matching '#{result.search_term}'"
                    else
                        matched_user_list = result.matches.map {|u| "'#{u}'"}.to_sentence
                        raise "No user found matching '#{result.search_term}' (already matched #{matched_user_list})"
                    end
                end
                matched_users << match
            end
            matched_users
        end

        def match_strategies
            [
            # Whole word of name
            lambda { |search_term, user| user.name =~ /\b#{search_term}\b/i },

            # Beginning of word in name
            lambda { |search_term, user| user.name =~ /\b#{search_term}/i },

            # Initials
            lambda do |search_term, user|
                initials = user.name.split(" ").map { |word| word.chars.first }.join
                initials =~ /#{search_term}/i
            end,

            # Segment anywhere in name or email
            lambda do |search_term, user|
                "#{user.name} #{user.email}" =~ /#{search_term}/i
            end
            ]
        end
    end
end


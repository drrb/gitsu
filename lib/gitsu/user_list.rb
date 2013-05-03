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
            all_users = list
            searches = all_matching_users(all_users, search_terms)
            searches.each do |search|
                if search.matches.empty?
                    raise "No user found matching '#{search.term}'"
                end
            end

            find_unique_combination(searches) or raise "Couldn't find a combination of unique users matching #{search_terms.map {|t| "'#{t}'" }.to_sentence}"
        end

        private
        class Search
            attr_accessor :term, :matches
            def initialize(term)
                @term, @matches = term, []
            end
        end

        def all_matching_users(all_users, search_terms)
            searches = search_terms.map {|search_term| Search.new(search_term)}
            searches.each do |search|
                match_strategies.each do |strategy|
                    search.matches += all_users.select { |user| strategy.call(search.term, user) }
                end
                search.matches.uniq!
            end
        end

        def find_unique_combination(searches)
            searches = searches.clone
            # Generate all combinations
            combinations = [[]]
            searches.each do |search|
                previous_combos = combinations.clone
                combinations = []
                previous_combos.each do |combo|
                    search.matches.each do |match|
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

        def match_strategies
            [
            # Whole word of name
            lambda { |search_term, user| user.name =~ /\b#{search_term}\b/i },

            # Beginning of word in name
            lambda { |search_term, user| user.name =~ /\b#{search_term}/i },

            # Initials
            lambda do |search_term, user|
                user.initials =~ /#{search_term}/i
            end,

            # Segment anywhere in name or email
            lambda do |search_term, user|
                "#{user.name} #{user.email}" =~ /#{search_term}/i
            end
            ]
        end
    end
end


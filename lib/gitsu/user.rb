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

require 'gitsu/array'

module GitSu
    class User
        class ParseError < RuntimeError
        end

        attr_accessor :names, :emails
        protected :names, :emails

        def initialize(name, email)
            @names, @emails = [name], [email]
        end

        NONE = User.new(nil, nil)
        def NONE.to_s
            "(none)"
        end
        def NONE.to_ansi_s(name_color, email_color, reset_color)
            name_color + to_s + reset_color
        end

        def User.parse(string)
            fully_qualified_user_regex = /^[^<]+<[^>]+>$/ 
            if string =~ fully_qualified_user_regex
                name = string[/^[^<]+/].strip
                email = string[/<.*>/].delete "[<>]" 
                User.new(name, email)
            else
                raise ParseError, "Couldn't parse '#{string}' as user (expected user in format: 'John Smith <jsmith@example.com>')"
            end
        end

        def combine(other, group_email)
            if none?
                other
            elsif other.none?
                self
            else
                clone.combine! other, group_email
            end
        end

        def clone
            deep_clone = super
            deep_clone.names = names.clone
            deep_clone.emails = emails.clone
            deep_clone
        end

        def name
            names = emails_and_names.map {|email,name| name}
            names.to_sentence
        end

        def email
            emails = emails_and_names.map {|email,name| email}
            if emails.size == 1
                emails.first
            else
                email_prefixes = emails.map { |email| email.sub /@.*/, '' }
                email_domain = emails.first.sub /^.*@/, ''
                group_email_prefix = @group_email.sub /@.*/, ''
                group_email_domain = @group_email.sub /^.*@/, ''
                group_email_prefix + '+' + email_prefixes.join('+') + '@' + group_email_domain
            end
        end

        def none?
            self === NONE
        end

        def ==(other)
            eql? other
        end

        def eql?(other)
            name == other.name && email == other.email
        end

        def hash
            to_s.hash
        end

        def to_ansi_s(name_color, email_color, reset_color)
            "#{name_color}#{name}#{reset_color} #{email_color}<#{email}>#{reset_color}"
        end

        def to_s
            to_ansi_s("", "", "")
        end

        protected
        def combine!(other, group_email)
            @names += other.names
            @emails += other.emails
            @group_email = group_email
            self
        end

        private
        # Array of emails and names, unique and ordered
        def emails_and_names
            combined = @emails.zip @names
            Hash[combined].sort 
        end
    end
end

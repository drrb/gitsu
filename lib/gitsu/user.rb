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

        def combine(other)
            if none?
                other
            elsif other.none?
                self
            else
                clone.combine! other
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
                email_prefixes.join('+') + '+dev@' + email_domain
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
        def combine!(other)
            @names += other.names
            @emails += other.emails
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

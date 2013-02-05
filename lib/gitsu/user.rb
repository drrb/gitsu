module GitSu
    class User
        NONE = User.new
        def NONE.to_s
            "(none)"
        end
        def NONE.to_ansi_s(name_color, email_color, reset_color)
            "#{name_color}(none)#{reset_color}"
        end

        class ParseError < RuntimeError
        end

        attr_accessor :name, :email

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

        def initialize(name, email)
            @name, @email = name, email
        end

        def none?
            self === NONE
        end

        def ==(other)
            eql? other
        end

        def eql?(other)
            @name == other.name && @email == other.email
        end

        def hash
            to_s.hash
        end

        def to_ansi_s(name_color, email_color, reset_color)
            "#{name_color}#{@name}#{reset_color} #{email_color}<#{@email}>#{reset_color}"
        end

        def to_s
            to_ansi_s("", "", "")
        end
    end
end

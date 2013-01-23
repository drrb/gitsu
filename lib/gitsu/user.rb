module GitSu
    class User
        attr_accessor :name, :email

        def User.parse(string)
            unless /^[^<]+<[^>]+>$/ =~ string
                raise "Couldn't parse '#{string}' as user (expected user in format: 'John Smith <jsmith@example.com>')"
            end
            name = string[/^[^<]+/].strip
            email = string[/<.*>/].delete "[<>]" 
            User.new(name, email)
        end

        def initialize(name, email)
            @name, @email = name, email
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

        def to_ansi_s(name_color = "\e[34m", email_color = "\e[34m", reset_color = "\e[0m")
            "#{name_color}#{@name}#{reset_color} #{email_color}<#{@email}>#{reset_color}"
        end

        def to_s
            to_ansi_s("", "", "")
        end
    end
end

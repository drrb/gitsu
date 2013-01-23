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

        def to_ansi_s
            "\e[34m#{to_s}\e[0m"
        end

        def to_s
            "#{@name} <#{@email}>"
        end
    end
end

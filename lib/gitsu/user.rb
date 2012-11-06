module GitSu
    class User
        attr_accessor :name, :email

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

        def to_s
            "#{@name} <#{@email}>"
        end
    end
end

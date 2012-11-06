module GitSu
    class User
        attr_accessor :name, :email

        def initialize(name, email)
            @name, @email = name, email
        end
    end
end

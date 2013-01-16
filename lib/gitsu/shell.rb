module GitSu
    class Shell
        def execute(command)
            `#{command}`.strip
        end

        def delegate(command)
            system command
        end
    end
end

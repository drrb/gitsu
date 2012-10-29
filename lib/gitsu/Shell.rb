module GitSu
    class Shell
        def execute(command)
            `#{command}`.strip
        end
    end
end

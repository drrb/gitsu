module GitSu
    class Shell
        def capture(command)
            output = `#{command}`.strip
            if block_given?
                yield(output, $?)
            end
            output
        end

        def execute(command)
            system command
        end
    end
end

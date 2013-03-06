module GitSu
    class Shell
        def capture(command)
            output = `#{command}`.strip
            if block_given?
                yield(output, $?)
            else
                output
            end
        end

        def execute(command)
            system command
        end
    end
end

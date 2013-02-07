module GitSu
    class Runner
        def initialize(output)
            @output = output
        end

        def run
            begin
                yield
            rescue Interrupt => interrupted
                @output.puts "Interrupted"
            rescue StandardError => error
                @output.puts error.message
            end
        end
    end
end


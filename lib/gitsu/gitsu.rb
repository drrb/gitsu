module GitSu
    class Gitsu
        def initialize(switcher)
            @switcher = switcher
        end

        def go(args)
            if args.empty?
                @switcher.print_current
            elsif args.include?("-c") || args.include?("--clear")
                @switcher.clear
            else
                @switcher.request(args.join " ")
            end
        end
    end
end


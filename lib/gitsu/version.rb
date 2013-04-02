module GitSu
    VERSION = "1.1.0"

    class Version
        class ParseError < StandardError
        end

        REGEX = /(\d+)\.(\d+).(\d+)/
        def self.parse(string)
            raise ParseError, "Couldn't parse string '#{string}' as version" unless REGEX =~ string
            parts = REGEX.match(string)[1..3].map {|e| e.to_i }
            Version.new(*parts)
        end

        def self.current
            Version.parse(VERSION)
        end

        def self.prompt(input, output, prompt, default)
            output.print "#{prompt} [#{default}]: "
            value = input.gets.strip
            if value.empty?
                default
            else
                Version.parse value
            end
        end

        attr_reader :major, :minor, :patch
        def initialize(major, minor, patch)
            @major, @minor, @patch = major, minor, patch
        end

        def next_minor
            Version.new(@major, @minor + 1, @patch)
        end

        def ==(other)
            eql? other
        end

        def eql?(other)
            major = other.major && minor == other.minor && patch == other.patch
        end

        def to_s
            "#{major}.#{minor}.#{patch}"
        end
    end
end

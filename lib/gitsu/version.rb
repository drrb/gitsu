# Gitsu
# Copyright (C) 2013 drrb
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

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

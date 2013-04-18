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

class Array
    def to_sentence
        if empty?
            ""
        elsif size == 1
            last.to_s
        else
            "#{self[0..-2].map{|e| e.to_s}.join(", ")} and #{last.to_s}"
        end
    end

    def pluralize(word)
        size > 1 ? word + "s" : word
    end
end

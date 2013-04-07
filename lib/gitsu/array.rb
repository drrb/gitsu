class Array
    def list
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

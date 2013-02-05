class Array
    def list
        if empty?
            ""
        elsif size == 1
            last.to_s
        else
            map{|e| e.to_s}.slice(0, length - 1).join(", ") + " and " + last.to_s
        end
    end

    def pluralize(word)
        size > 1 ? word + "s" : word
    end
end

module GitSu
    class CachingGitProxy
        def initialize(git)
            @git = git
        end

        def get_color(color_name)
            @colors ||= {}
            #TODO: what if it's an invalid color?
            @colors[color_name] ||= @git.get_color color_name
        end

        def color_output?
            @color_output.nil? ? @color_output = @git.color_output? : @color_output
        end

        def clear_user(scope)
            # Git complains if you try to clear the user when the config file is missing
            @git.clear_user(scope) unless @git.selected_user(scope).none?
        end

        def method_missing(name, *args, &block)
            @git.send(name, *args, &block) 
        end
    end

    class Switcher
        def initialize(git, user_list, output)
            @git, @user_list, @output = CachingGitProxy.new(git), user_list, output
        end

        def request(user, scope)
            begin
                matching_user = User.parse(user)
            rescue User::ParseError => parse_error
                matching_user = @user_list.find(user)
            end

            if matching_user.none?
                @output.puts "No user found matching '#{user}'"
            else
                @git.select_user(matching_user, scope)
                @output.puts "Switched #{scope} user to #{maybe_color matching_user}"
            end
        end
        
        def print_current(*scopes)
            if scopes.include? :all
                @output.puts "Current user: #{render_user(:derived)}"
                @output.puts
                @output.puts "Local: #{render_user(:local)}"
                @output.puts "Global: #{render_user(:global)}"
                @output.puts "System: #{render_user(:system)}"
            else
                scopes.each do |scope|
                    user = render_user(scope, true)
                    @output.puts user unless user.empty?
                end
            end
        end

        def edit_config
            @git.edit_gitsu_config
        end

        def clear(*scopes)
            scope_list = scopes.list

            if scopes.include? :all
                scopes = [:local, :global, :system]
            end

            @output.puts "Clearing Git #{scopes.pluralize('user')} in #{scope_list} #{scopes.pluralize('scope')}"
            scopes.each do |scope|
                @git.clear_user(scope)
            end
        end

        def list
            @user_list.list.each do |user|
                @output.puts maybe_color user
            end
        end

        def add(user_string)
            begin
                user = User.parse(user_string)
            rescue User::ParseError => parse_error
                @output.puts parse_error.message
                return
            end
            if @user_list.list.include? user
                @output.puts "User '#{user}' already in user list"
            else
                @user_list.add user
                @output.puts "User '#{user}' added to users"
            end
        end

        def render_user(scope, suppress_none = false)
            selected_user = @git.selected_user(scope)
            if selected_user.none? && suppress_none
                ""
            else
                maybe_color selected_user
            end
        end

        def maybe_color(user)
            if @git.color_output?
                user_color = @git.get_color "blue"
                email_color = @git.get_color "green"
                reset_color = @git.get_color "reset"
                user.to_ansi_s(user_color, email_color, reset_color)
            else
                user.to_s
            end
        end
    end
end

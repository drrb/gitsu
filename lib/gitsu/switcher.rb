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

module GitSu

    class Switcher
        def initialize(git, user_list, output)
            @git, @user_list, @output = git, user_list, output
        end

        def request(*users, scope)
            found_users = []
            users.each do |user|
                found_user = find user
                if found_user.none?
                    @output.puts "No user found matching '#{user}'"
                    return
                else
                    found_users << found_user
                end
            end
            found_user = combine found_users
            scope = scope == :default ? @git.default_select_scope : scope
            @git.select_user(found_user, scope)
            @output.puts "Switched #{scope} user to #{@git.render found_user}"
        end

        def find(user)
            begin
                User.parse(user)
            rescue User::ParseError => parse_error
                @user_list.find(user)
            end
        end

        def combine(users)
            names = users.map { |user| user.name }
            email_prefixes = users.map { |user| user.email.sub /@.*/, '' }
            email_domain = users.first.email.sub /^.*@/, ''
            if users.size == 1
                email = users.first.email
            else
                email = email_prefixes.join('+') + '+dev@' + email_domain
            end
            found_user = User.new(names.list, email)
        end
        
        def print_current(*scopes)
            if scopes.include? :all
                @output.puts "Current user: #{@git.render_user(:derived)}"
                @output.puts
                @output.puts "Local: #{@git.render_user(:local)}"
                @output.puts "Global: #{@git.render_user(:global)}"
                @output.puts "System: #{@git.render_user(:system)}"
            else
                scopes.each do |scope|
                    unless @git.selected_user(scope).none?
                        @output.puts @git.render_user(scope)
                    end
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
                @output.puts @git.render(user)
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
    end
end

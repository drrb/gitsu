Given /^no user is selected$/ do
    step "no user is selected in any scope"
end

Given /^no user is selected in any scope$/ do
    git.clear_users
end

Given /^user "(.*?)" is selected$/ do |user|
    git.select_user(GitSu::User.parse(user), :global)
end

Given /^user "(.*?)" is selected in "(.*?)" scope$/ do |user, scope|
    git.select_user(GitSu::User.parse(user), scope.to_sym)
end

Given /^user list is empty$/ do
    write_user_list("\n")
end

Given /^user list is$/ do |user_list|
    write_user_list user_list
end

Then /^user list should be$/ do |user_list|
    read_user_list.should eq user_list
end

And /^user list contains user "(.*?)" with email "(.*?)"$/ do |name, email|
    user_list.add GitSu::User.new(name, email)
end

def split_args_with_shell(arg_line)
    `for arg in #{arg_line}; do echo $arg; done`.strip.split("\n")
end

When /^I type "(.*?)"$/ do |command_line|
    arg_line = command_line.gsub(/^git su/, "")
    args = split_args_with_shell(arg_line)
    gitsu.go args
end

Then /^I should see$/ do |expected_output|
    output.messages.join("\n").should eq expected_output
end

Then /^I should see "(.*?)"$/ do |expected_output|
    matching_messages = output.messages.select {|e| e.include? expected_output}
    if matching_messages.empty?
        fail "Expected [#{output.messages}] to contain '#{expected_output}'"
    end
end

Then /^I shouldn't see anything$/ do
    output.messages.should be_empty
end

Then /^user "(.*?)" should be selected$/ do |user|
    step %[user "#{user}" should be selected in "global" scope] 
end

Then /^user "(.*?)" should be selected in "(.*?)" scope$/ do |user, scope|
    git.selected_user(scope.to_sym).should == GitSu::User.parse(user)
end

Then /^no user should be selected$/ do
    step 'no user should be selected in "global" scope'
end

Then /^no user should be selected in "(.*?)" scope$/ do |scope|
    git.selected_user(scope.to_sym).should be GitSu::User::NONE
end

Then /^the config file should be open in an editor$/ do
    git.editing?.should be true
end

class Output 
    def messages
        @messages ||= []
    end

    def puts(message = nil)
        messages << "#{message}"
    end
end

class StubGit 

    attr_accessor :users

    def initialize
        clear_users
        @editing = false
    end

    def select_user(user, scope)
        @users[scope] = user
    end

    def selected_user(scope)
        if scope == :derived
            @users[:local] || @users[:global] || @users[:system] || GitSu::User::NONE
        else
            @users[scope] || GitSu::User::NONE
        end
    end

    def clear_users
        @users = {}
    end

    def clear_user(scope)
        @users.delete scope
    end

    def edit_gitsu_config
        @editing = true
    end

    def color_output?
        false
    end

    def editing?
        @editing
    end
end

def output
    @output ||= Output.new
end

def git
    @git ||= StubGit.new 
end

def gitsu
    @gitsu ||= GitSu::Gitsu.new(switcher, output)
end

def switcher
    @switcher ||= GitSu::Switcher.new(git, user_list, output)
end

def user_list
    @user_list ||= GitSu::UserList.new(user_list_file)
end

def user_list_file
    @user_list_file ||= "/tmp/#{rand}"
end

def write_user_list(content)
    File.open(user_list_file, "w") do |f|
        f.write content
    end
end

def read_user_list
    File.read user_list_file
end

After do
    File.delete user_list_file if File.exist? user_list_file
end

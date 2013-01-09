Given /^no user is selected$/ do
    step "no user is selected in any scope"
end

Given /^no user is selected in any scope$/ do
    git.clear_user
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

And /^user list contains$/ do |user_list|
    write_user_list user_list
end

And /^user list contains user "(.*?)" with email "(.*?)"$/ do |name, email|
    user_list.add GitSu::User.new(name, email)
end

When /^I request "(.*?)"$/ do |argline|
    gitsu.go argline.split " "
end

When /^I request "(.*?)" in "(.*?)" scope$/ do |argline, scope|
    gitsu.go(argline.split(" ") + ["--#{scope}"])
end

When /^I request the options$/ do
    gitsu.go ["--help"]
end

When /^I request the current user$/ do
    gitsu.go []
end

When /^I request the current user in "(.*?)" scope$/ do |scope|
    gitsu.go ["--#{scope}"]
end

When /^I clear the user$/ do
    gitsu.go ["--clear"]
end

When /^I add the user "(.*?)"$/ do |user|
    gitsu.go ["--add", user]
end

When /^I list the users$/ do
    gitsu.go ["--list"]
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
    git.selected_user(scope.to_sym).should be nil
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

    def initialize
        clear_user
    end

    def select_user(user, scope)
        @users[scope] = user
    end

    def selected_user(scope)
        @users[scope]
    end

    def clear_user
        @users = {}
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

After do
    File.delete user_list_file if File.exist? user_list_file
end

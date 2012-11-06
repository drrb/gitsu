Given /^no user is selected$/ do
end

Given /^user "(.*?)" is selected$/ do |user|
    git.select_user user
end

And /^user list contains user "(.*?)" with email "(.*?)"$/ do |name, email|
    user_list.add(email, name)
end

When /^I request "(.*?)"$/ do |argline|
    gitsu.go argline.split " "
end

When /^I request the options$/ do
    gitsu.go ["--help"]
end

When /^I request the current user$/ do
    gitsu.go []
end

When /^I clear the user$/ do
    gitsu.go ["--clear"]
end

When /^I add the user "(.*?)"$/ do |user|
    gitsu.go ["--add", user]
end

Then /^I should see "(.*?)"$/ do |expected_output|
    matching_messages = output.messages.select {|e| e.include? expected_output}
    if matching_messages.empty?
        fail "Expected [#{output.messages}] to contain '#{expected_output}'"
    end
end

Then /^user "(.*?)" should be selected$/ do |user|
    git.selected_user.should == user
end

Then /^no user should be selected$/ do
    git.selected_user.should be nil
end

class Output 
    def messages
        @messages ||= []
    end

    def puts(message)
        messages << "#{message}"
    end
end

class StubGit 
    def select_user(user)
        @user = user
    end

    def selected_user 
        @user
    end

    def clear_user
        @user = nil
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
    @user_list ||= GitSu::UserList.new("/tmp/#{rand}")
end

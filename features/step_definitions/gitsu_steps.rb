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

Then /^I should see "(.*?)"$/ do |expected_output|
    output.messages.should include expected_output
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
        messages << message
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
    @gitsu ||= GitSu::Gitsu.new(switcher)
end

def switcher
    @switcher ||= GitSu::Switcher.new(git, user_list, output)
end

def user_list
    @user_list ||= GitSu::UserList.new("/tmp/#{rand}")
end

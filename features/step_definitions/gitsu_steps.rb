Given /^no user is selected$/ do
end

When /^I request '([^']+)'$/ do |user|
    switcher.request user  
end

Then /^I see '([^']+)'$/ do |expected_output|
    output.messages.should include expected_output
end

Then /^user '([^']+)' is selected$/ do |user|
    git.selected_user.should == user
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
end

def output
    @output ||= Output.new
end

def git
    @git ||= StubGit.new 
end

def switcher
    @switcher ||= GitSu::Switcher.new(git, output)
end

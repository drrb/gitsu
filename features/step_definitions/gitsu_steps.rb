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

Given /^the Git configuration has "(.*?)" set to "(.*?)"$/ do |key, value|
    git.set_config(:global, key, value)
end

Given /^user list is empty$/ do
    write_user_list("\n")
end

Given /^user list is$/ do |user_list|
    write_user_list user_list
end

Then /^user list should be$/ do |user_list|
    read_user_list.strip.should eq user_list
end

And /^user list contains user "(.*?)" with email "(.*?)"$/ do |name, email|
    user_list.add GitSu::User.new(name, email)
end

When /^I type "(.*?)"$/ do |command_line|
    arg_line = command_line.gsub(/^git su/, "")
    args = split_args_with_shell(arg_line)
    runner.run { gitsu.go args }
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

def split_args_with_shell(arg_line)
    `for arg in #{arg_line}; do echo $arg; done`.strip.split("\n")
end

class Output 
    def messages
        @messages ||= []
    end

    def puts(message = nil)
        messages << "#{message}"
    end
end

class StubFactory < GitSu::Factory
    def git
        @git ||= StubGit.new
    end
end

class StubGit < GitSu::Git
    attr_accessor :users

    def initialize
        clear_users
        @editing = false
    end

    def get_config(scope, key)
        if scope == :derived
            config(:local)[key] || config(:global)[key] || config(:system)[key] || ""
        else
            config(scope)[key] || ""
        end
    end

    def set_config(scope, key, value)
        config(scope)[key] = value
    end

    def unset_config(scope, key)
        config(scope).delete key
    end

    def list_config(scope)
        config(scope).map {|k,v| "#{k}=#{v}"}
    end

    def remove_config_section(scope, section)
        config(scope).reject! {|k,v| k =~ /^#{section}\./ }
    end

    def clear_users
        [:local, :global, :system].each do |scope|
            clear_user(scope)
        end
    end

    def config(scope)
        @config ||= {}
        @config[scope] ||= {}
    end

    def edit_gitsu_config
        @editing = true
    end

    def color_output?
        false
    end

    def render(user)
        user.to_s
    end

    def render_user(scope)
        render selected_user(scope)
    end

    def editing?
        @editing
    end
end

def output
    @output ||= Output.new
end

def git
    factory.git
end

def gitsu
    factory.gitsu
end

def runner
    factory.runner
end

def user_list
    factory.user_list
end

def factory
    @factory ||= StubFactory.new(output, user_list_file)
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

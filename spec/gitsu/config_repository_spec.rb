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

require 'spec_helper'

module GitSu
    describe ConfigRepository do
        let(:git) { double('git') }
        let(:repository) { ConfigRepository.new(git) }

        describe "#get" do
            it "looks up the specified config in Git" do
                git.should_receive(:get_config).with(:derived, "config.key").and_return "value"
                repository.get("config.key").should == "value"
            end
        end

        describe "#group_email_address" do
            context "when a group email address is configured" do
                it "returns the configured group email address" do
                    git.should_receive(:get_config).with(:derived, "gitsu.groupEmailAddress").and_return("pairs@example.org")
                    repository.group_email_address.should == "pairs@example.org"
                end
            end
            context "when no group email address is configured" do
                it "returns the placeholder group email address" do
                    git.should_receive(:get_config).with(:derived, "gitsu.groupEmailAddress").and_return("")
                    repository.group_email_address.should == "dev@example.com"
                end
            end
        end

        describe "#default_select_scope" do
            context "when a default selecton scope is configured" do
                it "returns the configured default scope" do
                    git.should_receive(:get_config).with(:derived, "gitsu.defaultSelectScope").and_return("global")
                    repository.default_select_scope.should == :global
                end
            end
            context "when no default selection scope is configured" do
                it "returns the conventional default scope (local)" do
                    git.should_receive(:get_config).with(:derived, "gitsu.defaultSelectScope").and_return("")
                    repository.default_select_scope.should == :local
                end
            end
            context "when an invalid default selection scope is configured" do
                it "dies noisily" do
                    git.should_receive(:get_config).with(:derived, "gitsu.defaultSelectScope").and_return("xxxxxx")
                    expect {repository.default_select_scope}.to raise_error(ConfigRepository::InvalidConfigError)
                end
            end
        end
    end
end

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

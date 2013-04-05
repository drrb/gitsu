require 'spec_helper'

module GitSu
    describe Shell do
        let(:shell) { Shell.new }

        describe "#capture" do
            it "executes the command and returns the output" do
                output = shell.capture 'echo hello'
                output.should == "hello"
            end
            it "calls the supplied block with the exit status and output" do
                command = 'echo hello && false'
                block_called = false
                return_value = shell.capture(command) do |output, result|
                    block_called = true
                    output.should == "hello"
                    result.exitstatus.should be 1
                end
                return_value.should == "hello"
                block_called.should be true
            end
        end

        describe "#execute" do
            context "when a command returns zero" do
                it "executes the command and returns true" do
                    shell.execute("true").should be true
                end
            end
            context "when a command returns nonzero" do
                it "executes the command and returns false" do
                    shell.execute("false").should be false
                end
            end
        end
    end
end


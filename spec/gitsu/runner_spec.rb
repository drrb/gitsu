require 'spec_helper'

module GitSu
    describe Runner do
        let(:output) { double('output') }
        let(:runner) { Runner.new(output) }

        describe "#run" do
            it "runs the block it's passed" do
                ran = false
                runner.run { ran = true }
                ran.should be true
            end

            it "catches interruptions" do
                output.should_receive(:puts).with "Interrupted"
                runner.run { raise Interrupt }
            end

            it "prints errors" do
                output.should_receive(:puts).with "Bad stuff happened"
                runner.run { raise "Bad stuff happened" }
            end
        end
    end
end


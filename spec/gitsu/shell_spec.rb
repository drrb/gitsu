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


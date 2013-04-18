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


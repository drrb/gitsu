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
    describe Version do
        describe "#parse" do
            it "parses a version string" do
                version = Version.parse("1.23.456")
                version.major.should be 1
                version.minor.should be 23
                version.patch.should be 456
            end
            context "when the input is invalid" do
                it "raises an exception" do
                    expect {Version.parse "x.x.x"}.to raise_error Version::ParseError
                end
            end
        end

        describe "#prompt" do
            let(:input) { double('input') }
            let(:output) { double('output') }
            let(:default) { Version.parse("1.2.3") }

            it "prompts the user to input a version" do
                output.should_receive(:print).with "Enter version [1.2.3]: "
                input.should_receive(:gets).and_return "4.5.6"
                version = Version.prompt(input, output, "Enter version", default)
                version.should == Version.parse("4.5.6")
            end
            context "when no version is provided by user" do
                it "returns the default value" do
                    output.should_receive(:print).with "Enter version [1.2.3]: "
                    input.should_receive(:gets).and_return ""
                    version = Version.prompt(input, output, "Enter version", default)
                    version.should == Version.parse("1.2.3")
                end
            end
        end

        describe "#current" do
            it "returns the current version" do
                Version.parse(VERSION).should == Version.current
            end
        end

        describe "#next_minor" do
            it "increments the minor version by 1 and resets the patch version to 0" do
                version = Version.parse("1.2.3")
                next_version = version.next_minor
                next_version.major.should be 1
                next_version.minor.should be 3
                next_version.patch.should be 0
            end
        end

        describe "#next_patch" do
            it "increments the patch number by 1" do
                version = Version.parse("1.2.3")
                next_version = version.next_patch
                next_version.major.should be 1
                next_version.minor.should be 2
                next_version.patch.should be 4
            end
        end
    end
end

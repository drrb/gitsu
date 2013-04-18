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

describe Array do
    describe "#to_sentence" do
        context "when array is empty" do
            let(:array) { [] }

            it "returns an empty string" do
                array.to_sentence.should == ""
            end
        end

        context "when array has one element" do
            let(:array) { [:apple] }

            it "returns the element as a string" do
                array.to_sentence.should == "apple"
            end
        end

        context "when array has two elements" do
            let(:array) { %w[apples oranges] }

            it "returns the elements with an 'and' in between" do
                array.to_sentence.should == "apples and oranges"
            end
        end

        context "when array has multiple elements" do
            let(:array) { %w[apples oranges bananas] }

            it "returns the elements as a sentence" do
                array.to_sentence.should == "apples, oranges and bananas"
            end
        end
    end

    describe "#pluralize" do
        context "when the array has one element" do
            let(:array) { [:apple] }

            it "returns the word unchanged" do
                array.pluralize("fruit").should == "fruit"
            end
        end

        context "when the array has more than one element" do
            let(:array) { [:apple, :orange] }

            it "returns the word with an 's' on the end" do
                array.pluralize("fruit").should == "fruits"
            end
        end
    end
end

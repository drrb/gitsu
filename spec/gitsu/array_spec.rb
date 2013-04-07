require 'spec_helper'

describe Array do
    describe "#list" do
        context "when array is empty" do
            let(:array) { [] }

            it "returns an empty string" do
                array.list.should == ""
            end
        end

        context "when array has one element" do
            let(:array) { [:apple] }

            it "returns the element as a string" do
                array.list.should == "apple"
            end
        end

        context "when array has two elements" do
            let(:array) { %w[apples oranges] }

            it "returns the elements with an 'and' in between" do
                array.list.should == "apples and oranges"
            end
        end

        context "when array has multiple elements" do
            let(:array) { %w[apples oranges bananas] }

            it "returns the elements as a sentence" do
                array.list.should == "apples, oranges and bananas"
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

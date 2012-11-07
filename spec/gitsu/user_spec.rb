module GitSu
    describe User do
        describe "#parse" do
            context "when passed a valid mail string (e.g. 'John Galt <jgalt@example.com>')" do
                it "parses a user from the supplied string " do
                    user = User.parse('John Galt <jgalt@example.com>')
                    user.name.should == 'John Galt'
                    user.email.should == 'jgalt@example.com'
                end
            end

            context "when passed an invalid string" do
                it "throws an exception" do
                    expect { User.parse('xxx') }.to raise_error Exception
                end
            end
        end
    end
end

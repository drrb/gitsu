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
                it "raises error" do
                    expect {User.parse('xxx')}.to raise_error User::ParseError
                end
            end
        end

        describe "#to_s" do
            it "returns a string representation of the user" do
                user = User.new("John Galt", "jg@example.com")
                user.to_s.should == "John Galt <jg@example.com>"
            end
        end

        describe "#to_ansi_s" do
            it "returns a colored string representation of the user" do
                user = User.new("John Galt", "jg@example.com")
                user.to_ansi_s("\e[34m", "\e[35m", "\e[0m").should == "\e[34mJohn Galt\e[0m \e[35m<jg@example.com>\e[0m"
            end
        end
    end
end

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

        describe "#combine" do
            it "combines the user with the provided other user" do
                user = User.new("John A", "ja@example.com")
                other = User.new("John B", "jb@example.com")
                combined_user = user.combine other
                combined_user.name.should == "John A and John B"
                combined_user.email.should == "ja+jb+dev@example.com"
            end
            it "accumulates users" do
                user1 = User.new("John A", "ja@example.com")
                user2 = User.new("John B", "jb@example.com")
                user3 = User.new("John C", "jc@example.com")
                combined_user = user1.combine(user2).combine(user3)
                combined_user.name.should == "John A, John B and John C"
                combined_user.email.should == "ja+jb+jc+dev@example.com"
            end
            it "can be called with combined users" do
                user1 = User.new("John A", "ja@example.com")
                user2 = User.new("John B", "jb@example.com")
                user3 = User.new("John C", "jc@example.com")
                combined_user = user1.combine(user2)
                combined_user = user3.combine(combined_user)
                combined_user.name.should == "John A, John B and John C"
                combined_user.email.should == "ja+jb+jc+dev@example.com"
            end
            it "removes duplicate users by email" do
                user = User.new("John A", "ja@example.com")
                other = User.new("John B", "ja@example.com")
                combined_user = user.combine other
                combined_user.name.should == "John B"
                combined_user.email.should == "ja@example.com"
            end
            it "sorts combined users by email" do
                user1 = User.new("John Z", "ja@example.com")
                user2 = User.new("John X", "jc@example.com")
                user3 = User.new("John Y", "jb@example.com")
                combined_user = user1.combine(user2).combine(user3)
                combined_user.name.should == "John Z, John Y and John X"
                combined_user.email.should == "ja+jb+jc+dev@example.com"
            end
            it "doesn't have side-effects" do
                ja = User.new("John A", "ja@example.com")
                jb = User.new("John B", "jb@example.com")
                combined_user = ja.combine(jb)
                ja.name.should == "John A"
                ja.email.should == "ja@example.com"
            end
            context "when combined with NONE" do
                it "returns a clone of itself" do
                    ja = User.new("John A", "ja@example.com")
                    ja.combine(User::NONE).should == ja
                    User::NONE.combine(ja).should == ja
                end
            end
        end
    end
end

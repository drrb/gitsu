Feature: Switch to multiple users
    As a pairer
    I want to select multiple Git users at once
    So that I can commit code that I created with my pair

    Scenario: Switch to fully qualified users
        Given no user is selected
        When I type "git su 'John Galt <jg@example.com>' 'Joseph Porter <jp@example.com>'"
        Then I should see "Switched local user to John Galt and Joseph Porter <dev+jg+jp@example.com>"
        And user "John Galt and Joseph Porter <dev+jg+jp@example.com>" should be selected in "local" scope

    Scenario: Switch to stored users
        Given no user is selected
        Given user list is
        """
        a@example.com: Johnny Z
        c@example.com: Johnny X
        b@example.com: Johnny Y
        """
        When I type "git su jy jx jz"
        Then I should see "Switched local user to Johnny Z, Johnny Y and Johnny X <dev+a+b+c@example.com>"
        And user "Johnny Z, Johnny Y and Johnny X <dev+a+b+c@example.com>" should be selected in "local" scope

    Scenario: User not found
        Given user list is
        """
        porter@example.com: Joseph Porter
        """
        When I type "git su frances joseph"
        Then I should see "No user found matching 'frances'"
        And no user should be selected in "local" scope

    Scenario: User already matched
        Given user list is
        """
        a@example.com: Johnny A
        b@example.com: Johnny B
        """
        When I type "git su ja jb ja"
        Then I should see "No user found matching 'ja' (already matched 'Johnny A <a@example.com>')"

    Scenario: No group email configured
        Given the Git configuration has "gitsu.groupEmailAddress" set to ""

    Scenario: Group email configured
        Given the Git configuration has "gitsu.groupEmailAddress" set to "pairs@example.org"
        When I type "git su 'John Galt <jg@example.com>' 'Joseph Porter <jp@example.com>'"
        And user "John Galt and Joseph Porter <pairs+jg+jp@example.org>" should be selected in "local" scope

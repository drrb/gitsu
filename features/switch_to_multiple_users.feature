Feature: Switch to multiple users
    As a pairer
    I want to select multiple Git users at once
    So that I can commit code that I created with my pair

    Scenario: Switch to fully qualified users
        Given no user is selected
        When I type "git su 'John Galt <jg@example.com>' 'Joseph Porter <jp@example.com>'"
        Then I should see "Switched local user to John Galt and Joseph Porter <jg+jp+dev@example.com>"
        And user "John Galt and Joseph Porter <jg+jp+dev@example.com>" should be selected in "local" scope

    Scenario: Switch to stored users
        Given no user is selected
        Given user list is
        """
        rackstraw@example.com: Raphe Rackstraw
        porter@example.com: Joseph Porter
        """
        When I type "git su port rack"
        Then I should see "Switched local user to Joseph Porter and Raphe Rackstraw <porter+rackstraw+dev@example.com>"
        And user "Joseph Porter and Raphe Rackstraw <porter+rackstraw+dev@example.com>" should be selected in "local" scope

    Scenario: User not found
        Given user list is
        """
        porter@example.com: Joseph Porter
        """
        When I type "git su frances joseph"
        Then I should see "No user found matching 'frances'"
        And no user should be selected in "local" scope

    Scenario: Conglomerate users in alphabetical order by email
        Given no user is selected
        Given user list is
        """
        a@example.com: Johnny Z
        c@example.com: Johnny X
        b@example.com: Johnny Y
        """
        When I type "git su jy jx jz"
        Then I should see "Switched local user to Johnny Z, Johnny Y and Johnny X <a+b+c+dev@example.com>"
        And user "Johnny Z, Johnny Y and Johnny X <a+b+c+dev@example.com>" should be selected in "local" scope

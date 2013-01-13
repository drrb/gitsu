Feature: Switch to stored user
    As an user
    I want to quickly switch to my user
    So that I can commit code

    Scenario Outline: Switch to stored user
        Given no user is selected
        And user list is
        """
        rackstraw@github.com: Raphe Rackstraw
        """
        When I type "git su <request>"
        Then I should see "<output>"
        And user "<selected_user>" should be selected in "local" scope

        Scenarios: Existing user match
            | request   | selected_user                           | output                                                          |
            | raphe     | Raphe Rackstraw <rackstraw@github.com>  | Switched local user to Raphe Rackstraw <rackstraw@github.com>  |
            | Raphe     | Raphe Rackstraw <rackstraw@github.com>  | Switched local user to Raphe Rackstraw <rackstraw@github.com>  |
            | git       | Raphe Rackstraw <rackstraw@github.com>  | Switched local user to Raphe Rackstraw <rackstraw@github.com>  |
            | rr        | Raphe Rackstraw <rackstraw@github.com>  | Switched local user to Raphe Rackstraw <rackstraw@github.com>  |
            | RR        | Raphe Rackstraw <rackstraw@github.com>  | Switched local user to Raphe Rackstraw <rackstraw@github.com>  |

    Scenario: No match found
        Given no user is selected
        And user list contains user "Raphe Rackstraw" with email "rrackstraw@github.com"
        When I type "git su joe"
        Then I should see "No user found matching 'joe'"
        And no user should be selected

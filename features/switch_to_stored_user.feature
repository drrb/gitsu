Feature: Switch to stored user
    As an user
    I want to quickly switch to my user
    So that I can commit code

    Scenario Outline: Switch to stored user
        Given no user is selected
        And user list contains user "Raphe Rackstraw" with email "rrackstraw@github.com"
        When I request "<request>"
        Then I should see "<output>"
        And user "<selected_user>" should be selected

        Scenarios: Existing user match
            | request   | selected_user                           | output                                                    |
            | raphe     | Raphe Rackstraw <rrackstraw@github.com> | Switched to user Raphe Rackstraw <rrackstraw@github.com>  |
            | rrack     | Raphe Rackstraw <rrackstraw@github.com> | Switched to user Raphe Rackstraw <rrackstraw@github.com>  |

Feature: Switch to stored user
    As an user
    I want to quickly switch to my user
    So that I can commit code

    Scenario: Switch to stored user
        Given no user is selected
        And user list contains user "Raphe Rackstraw" with email "rrackstraw@github.com"
        When I request "raphe"
        Then I should see "Switched to user Raphe Rackstraw <rrackstraw@github.com>"
        And user "Raphe Rackstraw <rrackstraw@github.com>" should be selected

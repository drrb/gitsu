Feature: Switch to fully qualified user
    As a new user
    I want to switch to my Git user
    So that I can commit code

    Scenario: Switch to fully qualified user
        Given no user is selected
        When I type "git su 'John Galt <jg@example.com>'"
        Then I should see "Switched local user to John Galt <jg@example.com>"
        And user "John Galt <jg@example.com>" should be selected in "local" scope

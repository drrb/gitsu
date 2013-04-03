Feature: Switch to multiple users
    As a pairer
    I want to select multiple Git users at once
    So that I can commit code that I created with my pair

    Scenario: Switch to fully qualified user
        Given no user is selected
        When I type "git su 'John Galt <jg@example.com>' 'Joseph Porter <jp@example.com>'"
        Then I should see "Switched local user to John Galt and Joseph Porter <jg+jp+dev@example.com>"
        And user "John Galt and Joseph Porter <jg+jp+dev@example.com>" should be selected in "local" scope

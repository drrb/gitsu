Feature: Print options
    As a user
    I want to view Gitsu's options
    So that I know how to use it

    Scenario: Print options
        When I request the options
        Then I should see "Usage: git-su"

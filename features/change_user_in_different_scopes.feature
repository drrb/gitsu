Feature: Change user in different scopes
    As a user with multiple projects
    I want to change my user in different scopes
    So that I have greater control over repositories

    Scenario Outline: change user in scope
        Given no user is selected in any scope
        When I type "git su 'John Galt <jgalt@example.com>' --<selected>"
        Then user "John Galt <jgalt@example.com>" should be selected in "<selected>" scope
        And no user should be selected in "<not_selected>" scope
        And no user should be selected in "<also_not_selected>" scope

        Scenarios:
            | selected | not_selected | also_not_selected |
            | local    | global       | system            |
            | global   | local        | system            |
            | system   | local        | global            |

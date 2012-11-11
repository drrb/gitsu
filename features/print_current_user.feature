Feature: Print the current user 
    As a user
    I want to see who is currently logged in 
    So that I know if I need to switch users 

    Scenario Outline: Print current user
        Given user "Johnny System <jsystem@gitsu.com>" is selected in "system" scope
        And user "Johnny Global <jglobal@gitsu.com>" is selected in "global" scope
        And user "Johnny Local <jlocal@gitsu.com>" is selected in "local" scope
        When I request the current user in "<scope>" scope
        Then I should see "Current user: <user>"

        Scenarios: Selected Users
            | scope  | user                              |
            | system | Johnny System <jsystem@gitsu.com> |
            | global | Johnny Global <jglobal@gitsu.com> |
            | local  | Johnny Local <jlocal@gitsu.com>   |

    Scenario: User is selected in specified scope
        Given user "John Galt <jg@example.com>" is selected in "global" scope
        When I request the current user in "global" scope
        Then I should see "Current user: John Galt <jg@example.com>"

    Scenario: No user is selected
        Given no user is selected in any scope
        When I request the current user
        Then I should see "Current user: (none)"

Feature: Print the current user 
    As a user
    I want to see who is currently logged in 
    So that I know if I need to switch users 

    Scenario Outline: Print current user
        Given user "Johnny System <jsystem@gitsu.com>" is selected in "system" scope
        And user "Johnny Global <jglobal@gitsu.com>" is selected in "global" scope
        And user "Johnny Local <jlocal@gitsu.com>" is selected in "local" scope
        When I type "git su --<scope>"
        Then I should see "<output>"

        Scenarios: Selected Users
            | scope  | output                                         |
            | system | System user: Johnny System <jsystem@gitsu.com> |
            | global | Global user: Johnny Global <jglobal@gitsu.com> |
            | local  | Local user: Johnny Local <jlocal@gitsu.com>    |

    Scenario: No user is selected
        Given no user is selected in any scope
        When I type "git su"
        Then I should see "Current user: (none)"

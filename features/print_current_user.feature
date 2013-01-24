Feature: Print the current user 
    As a user
    I want to see who is currently logged in 
    So that I know if I need to switch users 

    Scenario Outline: Print current user in different scopes
        Given user "Johnny System <jsystem@gitsu.com>" is selected in "system" scope
        And user "Johnny Global <jglobal@gitsu.com>" is selected in "global" scope
        And user "Johnny Local <jlocal@gitsu.com>" is selected in "local" scope
        When I type "git su --<scope>"
        Then I should see "<output>"

        Scenarios: Selected Users
            | scope  | output                                         |
            | system | Johnny System <jsystem@gitsu.com> |
            | global | Johnny Global <jglobal@gitsu.com> |
            | local  | Johnny Local <jlocal@gitsu.com>    |

    Scenario: Print all users
        Given user "Johnny System <jsystem@gitsu.com>" is selected in "system" scope
        And user "Johnny Global <jglobal@gitsu.com>" is selected in "global" scope
        And user "Johnny Local <jlocal@gitsu.com>" is selected in "local" scope
        When I type "git su"
        Then I should see
        """
        Current user: Johnny Local <jlocal@gitsu.com>

        Local: Johnny Local <jlocal@gitsu.com>
        Global: Johnny Global <jglobal@gitsu.com>
        System: Johnny System <jsystem@gitsu.com>
        """

    Scenario: No user is selected
        Given no user is selected in any scope
        When I type "git su"
        Then I should see "Current user: (none)"

    Scenario: No user is selected in the specified scope
        Given no user is selected in any scope
        When I type "git su --local"
        Then I shouldn't see anything

    Scenario: No user is selected in a specified scope
        Given user "Johnny System <jsystem@gitsu.com>" is selected in "system" scope
        When I type "git su --local --system"
        Then I should see
        """
        Johnny System <jsystem@gitsu.com>
        """

    Scenario: Multiple scopes specified
        Given user "Johnny System <jsystem@gitsu.com>" is selected in "system" scope
        And user "Johnny Global <jglobal@gitsu.com>" is selected in "global" scope
        And user "Johnny Local <jlocal@gitsu.com>" is selected in "local" scope
        When I type "git su --local --system"
        Then I should see
        """
        Johnny Local <jlocal@gitsu.com>
        Johnny System <jsystem@gitsu.com>
        """

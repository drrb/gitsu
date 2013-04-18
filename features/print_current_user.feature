# Gitsu
# Copyright (C) 2013 drrb
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

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

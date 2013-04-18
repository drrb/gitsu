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

    Scenario: change user in multiple scopes
        Given no user is selected in any scope
        When I type "git su 'John Galt <jgalt@example.com>' --local --global"
        Then user "John Galt <jgalt@example.com>" should be selected in "local" scope
        And user "John Galt <jgalt@example.com>" should be selected in "global" scope
        And no user should be selected in "system" scope

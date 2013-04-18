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

Feature: Switch to stored user
    As an user
    I want to quickly switch to my user
    So that I can commit code

    Scenario Outline: One match found
        Given no user is selected
        And user list is
        """
        rackstraw@github.com: Raphe Rackstraw
        """
        When I type "git su <request>"
        Then I should see "<output>"
        And user "<selected_user>" should be selected in "local" scope

        Scenarios: Existing user match
            | request   | selected_user                           | output                                                          |
            | raphe     | Raphe Rackstraw <rackstraw@github.com>  | Switched local user to Raphe Rackstraw <rackstraw@github.com>  |
            | Raphe     | Raphe Rackstraw <rackstraw@github.com>  | Switched local user to Raphe Rackstraw <rackstraw@github.com>  |
            | git       | Raphe Rackstraw <rackstraw@github.com>  | Switched local user to Raphe Rackstraw <rackstraw@github.com>  |
            | rr        | Raphe Rackstraw <rackstraw@github.com>  | Switched local user to Raphe Rackstraw <rackstraw@github.com>  |
            | RR        | Raphe Rackstraw <rackstraw@github.com>  | Switched local user to Raphe Rackstraw <rackstraw@github.com>  |

    Scenario: No match found
        Given no user is selected
        And user list contains user "Raphe Rackstraw" with email "rrackstraw@github.com"
        When I type "git su joe"
        Then I should see "No user found matching 'joe'"
        And no user should be selected

    Scenario Outline: Multiple matches found
        Given no user is selected
        And user list is
        """
        jdean@github.com: James Dean
        jack@github.com: Jacky Smith
        jim@github.com: Jack Smythe
        amos@github.com: Amos Arphaxad
        molly@github.com: Molly Meldrum
        """
        When I type "git su <request>"
        Then user "<selected_user>" should be selected in "local" scope

        Scenarios: Existing user match
            | request   | selected_user                           | reason                   |
            | jack      | Jack Smythe <jim@github.com>            | exact first name match   |
            | am        | Amos Arphaxad <amos@github.com>         | first name snippet       |
            | me        | Molly Meldrum <molly@github.com>        | other name snippet       |


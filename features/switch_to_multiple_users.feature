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

Feature: Switch to multiple users
    As a pairer
    I want to select multiple Git users at once
    So that I can commit code that I created with my pair

    Scenario: Switch to fully qualified users
        Given no user is selected
        When I type "git su 'John Galt <jg@example.com>' 'Joseph Porter <jp@example.com>'"
        Then I should see "Switched local user to John Galt and Joseph Porter <dev+jg+jp@example.com>"
        And user "John Galt and Joseph Porter <dev+jg+jp@example.com>" should be selected in "local" scope

    Scenario: Switch to stored users
        Given no user is selected
        Given user list is
        """
        a@example.com: Johnny Z
        c@example.com: Johnny X
        b@example.com: Johnny Y
        """
        When I type "git su jy jx jz"
        Then I should see "Switched local user to Johnny Z, Johnny Y and Johnny X <dev+a+b+c@example.com>"
        And user "Johnny Z, Johnny Y and Johnny X <dev+a+b+c@example.com>" should be selected in "local" scope

    Scenario: User not found
        Given user list is
        """
        porter@example.com: Joseph Porter
        """
        When I type "git su frances joseph"
        Then I should see "No user found matching 'frances'"
        And no user should be selected in "local" scope

    Scenario: User already matched
        Given user list is
        """
        a@example.com: Johnny A
        b@example.com: Johnny B
        """
        When I type "git su ja jb ja"
        Then I should see "Couldn't find a combination of users matching 'ja', 'jb' and 'ja'"

    Scenario: No group email configured
        Given the Git configuration has "gitsu.groupEmailAddress" set to ""

    Scenario: Group email configured
        Given the Git configuration has "gitsu.groupEmailAddress" set to "pairs@example.org"
        When I type "git su 'John Galt <jg@example.com>' 'Joseph Porter <jp@example.com>'"
        And user "John Galt and Joseph Porter <pairs+jg+jp@example.org>" should be selected in "local" scope

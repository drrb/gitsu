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

Feature: Add user
    As a new user
    I want to add myself to the GitSu config
    So that I can quickly switch back to myself

    Scenario: Add user
        Given no user is selected
        When I type "git su --add 'John Galt <jgalt@example.com>'"
        Then I should see "User 'John Galt <jgalt@example.com>' added to users"

    Scenario: Try to add existing user
        Given user list is 
            """
            jgalt@example.com: John Galt
            """
        When I type "git su --add 'John Galt <jgalt@example.com>'"
        Then I should see "User 'John Galt <jgalt@example.com>' already in user list"
        And user list should be 
            """
            jgalt@example.com: John Galt
            """

    Scenario: Try to add invalid user
        Given no user is selected
        When I type "git su --add xxx"
        Then I should see "Couldn't parse 'xxx' as user (expected user in format: 'John Smith <jsmith@example.com>')"

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

Feature: List users
    As a user
    I want to list all users
    So that I can see if the user I want is in the config

    Scenario: list users
        Given user list contains user "John Galt" with email "jgalt@example.com" 
        And user list contains user "Raphe Rackstraw" with email "rrack@github.com" 
        When I type "git su --list"
        Then I should see "John Galt <jgalt@example.com>"
        And I should see "Raphe Rackstraw <rrack@github.com>"

    Scenario: no users configured yet 
        Given user list is empty 
        When I type "git su --list"
        Then I shouldn't see anything

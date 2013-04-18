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

Feature: Configure default scope
    As a user of a shared environment
    I want to configure the default scope
    So that I can change the user for all projects at once

    Scenario: No default scope specified
        When I type "git su 'John Galt <jgalt@example.com>'"
        Then I should see "Switched local user to John Galt <jgalt@example.com>"

    Scenario: Default scope specified
        Given the Git configuration has "gitsu.defaultSelectScope" set to "global"
        When I type "git su 'John Galt <jgalt@example.com>'"
        Then I should see "Switched global user to John Galt <jgalt@example.com>"

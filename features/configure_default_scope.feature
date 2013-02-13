Feature: Configure default scope
    As a user of a shared environment
    I want to configure the default scope
    So that I can change the user for all projects at once

    Scenario: Default to global scope
        Given the Git configuration has "git-su.defaultScope" set to "global"
        When I type "git su 'John Galt <jgalt@example.com>'"
        Then I should see "Switched global user to John Galt <jgalt@example.com>"

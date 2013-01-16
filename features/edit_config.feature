Feature: Edit config file
    As a user
    I want to quickly open the config file in an editor
    So that I can quickly edit the configured users

    Scenario: Edit config
        When I type "git su --edit"
        Then the config file should be open in an editor

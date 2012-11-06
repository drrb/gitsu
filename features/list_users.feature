Feature: List users
    As a user
    I want to list all users
    So that I can see if the user I want is in the config

    Scenario: list users
        Given user list contains user "John Galt" with email "jgalt@example.com" 
        And user list contains user "Raphe Rackstraw" with email "rrack@github.com" 
        When I list the users
        Then I should see "John Galt <jgalt@example.com>"
        And I should see "Raphe Rackstraw <rrack@github.com>"

    Scenario: no users configured yet 
        Given user list is empty 
        When I list the users
        Then I shouldn't see anything

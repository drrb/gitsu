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

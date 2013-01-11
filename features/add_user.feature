Feature: Add user
    As a new user
    I want to add myself to the GitSu config
    So that I can quickly switch back to myself

    Scenario: Add user
        Given no user is selected
        When I type "git su --add 'John Galt <jgalt@example.com>'"
        Then I should see "User 'John Galt <jgalt@example.com>' added to users"
        And user "John Galt <jgalt@example.com>" should be selected in "local" scope

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

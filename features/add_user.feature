Feature: Add user
    As a new user
    I want to add myself to the GitSu config
    So that I can quickly switch back to myself

    Scenario: Add user
        Given no user is selected
        When I add the user "John Galt <jgalt@example.com>"
        Then I should see "User 'John Galt <jgalt@example.com>' added to users"
        And user "John Galt <jgalt@example.com>" should be selected


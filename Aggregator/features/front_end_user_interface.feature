# This is a collection of scenarios that govern the front end user interface of the aggregator

@aggregate @front_end_user @challenge_index_page
Feature: Actions on challenges index page

# TODO: Add Scenario: Test sorting and string filter together
# TODO: Add Scenario: Going back and forth in instances to make sure filtering is retained when "going back" 
# TODO: Define if there is any entrance criteria of prior sorting knowledge that we may want to maintain
# TODO: Add a Individual challenge definition feature

Background:
    Given the user is at the general challenges index page
                 
	Scenario: Default challenges index page
	    Given the user is at the default landing page
		And the challenges are sorted by deadline in descending order
		
# TEST NOTE: Make a step of the above	

	Scenario Outline: Sort challenges
		Given the present order was "<old_order>"
		And the user clicks sort by "<parameter>"
		And the previous order was "<new_order>"
		Then the list of challenges is correctly sorted
		And the user is at the first page of viewable challenges
	
# TEST NOTE: For each example, compare the first challenge with the second, the 
#            last against the second to last, and the tenth against the eleventh
#            to verify correct order is in place.
	
	    Examples: These examples should work
	        | old_order     | parameter     | order         | 
	        | descending    | title         | ascending     | 
	        | ascending     | title         | descending    | 
	        | descending    | award         | ascending     | 
	        | ascending     | award         | descending    |
	        | descending    | deadline      | ascending     |
	        | ascending     | deadline      | descending    |
	        | descending    | start date    | ascending     |
	        | ascending     | start date    | descending    |
	        
	    Examples: These examples are expected to fail
	        | old_order     | parameter     | order         | 
	        | ascending     | title         | ascending     | 
	        | descending    | title         | descending    | 
	        | ascending     | award         | ascending     | 
	        | descending    | award         | descending    |
	        | ascending     | deadline      | ascending     |
	        | descending    | deadline      | descending    |
	        | ascending     | start date    | ascending     |
	        | descending    | start date    | descending    |
	        
# TODO: Think about if the "start range"/"award range"/"end range" sorting option is preferred here at this point

# TEST NOTE: Make a step of the above

	Scenario Outline: String search challenges
		Given the loaded database in use is "<db>"
		# Test dependent
		And the user enters "<keyword>" into the search box
		And the user clicks the search button
		Then the viewable challenges all contain "<keyword>" in at least one of their fields
		And there are now "<this_many>" viewable challenges
		And the "<keyword>" string should remain in the search box
		And the pagination links reflect the number of viewable pages
		And the user should see a button that remove the string search filter
		
		Examples: Database 1 that should work
	        | db    | keyword    | this_many    |
	        | 1     | NASA       | 2            |
	        | 1     | Millenium  | 6            |
	        | 1     | sexfoot    | 0            |
	        | 1     | sexfoot    | 0            |
	        | 1     | sexfoot    | 0            |	        	        
	        | 1     | sexfoot    | 0            |
	        | 1     | sexfoot    | 0            |

	    Examples: Database 2 that should work
	        | db    | keyword    | this_many    |
	        | 2     | NASA       | 2            |
	        | 2     | Millenium  | 6            |
	        | 2     | sexfoot    | 0            |
	        | 2     | sexfoot    | 0            |
	        | 2     | sexfoot    | 0            |	        	        
	        | 2     | sexfoot    | 0            |
	        | 2     | sexfoot    | 0            |
	    
	    Examples: Database 3 that should work
	        | db    | keyword    | this_many    |
	        | 3     | NASA       | 2            |
	        | 3     | Millenium  | 6            |
	        | 3     | sexfoot    | 0            |
	        | 3     | sexfoot    | 0            |
	        | 3     | sexfoot    | 0            |	        	        
	        | 3     | sexfoot    | 0            |
	        | 3     | sexfoot    | 0            |
	        
	    Examples: Databases 1-3 that are expected to fail
	        | db    | sexfoot    | this_many    |
	        | 1     | sexfoot    | 2            |
	        | 1     | sexfoot    | 6            |
	        | 1     | sexfoot    | 0            |
	        | 2     | sexfoot    | 0            |
	        | 2     | sexfoot    | 0            |	
	        | 2     | sexfoot    | 0            |	        	        
	        | 3     | sexfoot    | 0            |        	        
	        | 3     | sexfoot    | 0            |
	        | 3     | sexfoot    | 0            |
	        
# TODO: Make better examples here when we learn more
# TEST NOTE: Make a step of the above
	        
	Scenario: Return to full challenge index after string searching challenges
		Given there is a string search filter on the displayed challenges
		And the user clicks on the button to remove the string search filter
		Then the pagination links reflect the number of viewable pages
		And the user should not see a button that remove the string search filter
		And the search box should contain no strings

# TEST NOTE: Make a step of the above

	Scenario Outline: View individual challenge
	
# TEST NOTE: Max indicates the number of active challenges in the database
	
		Given the loaded database in use is "<db>"
		# Test dependent
		And the user clicks on the individual challenge link for the "<chosen>" challenge
		Then the user is at an individual challenge page for the "<chosen>" challenge
		
	    Examples: Database 1
	        | db    | chosen    |
	        | 1     | 1         |
	        | 1     | 2         |
	        | 1     | 10        |
	        | 1     | 11        |
	        | 1     | max-1     |
	        | 1     | max       |
	        
	    Examples: Database 2
	        | db    | chosen    |
	        | 2     | 1         |
	        | 2     | 2         |
	        | 2     | 10        |
	        | 2     | 11        |
	        | 2     | max-1     |
	        | 2     | max       |

	    Examples: Database 3
	        | db    | chosen    |
	        | 3     | 1         |
	        | 3     | 2         |
	        | 3     | 10        |
	        | 3     | 11        |
	        | 3     | max-1     |
	        | 3     | max       |

# TODO: Make better examples here when we learn more
# TEST NOTE: Make a step of the above

    Scenario: Individual challenge page landing
        Given the user is at an individual challenge page
        Then there exists a hyperlink to the URL in the URL parameter
        And there exists a link to email the challenge page data
        And there exists a link to post this challenge page to facebook
        And there exists a link to post this url to twitter
        And there exists a link to return to the challenge index
        And there exists a link to the about us page	    

#############################################################################		
#                              NEW FEATURE                                  #
#############################################################################

@aggregate @front_end_user @challenge_index_page
Feature: General challenges index definition
                 
	Scenario: General landing page
	    Given the user is at the first page of viewable challenges
        And there are learn more links for each of the viewable challenges
		And there is no string in the search string text box
		And the pagination links reflect the number of viewable pages
	    And there exists a link to the about us page
	    And there is a link to sort by title
        And there is a link to sort by award
        And there is a link to sort by deadline
        And there is a link to sort by start date

# TEST NOTE: Make a step of the above

#############################################################################		
#                              NEW FEATURE                                  #
#############################################################################

@aggregate @front_end_user @challenge_index_page
Feature: First landing page

    Scenario:
        Given the user is arriving to the site for the first time
        Then the user is at the default challenges index page		
        
#############################################################################		
#                              NEW FEATURE                                  #
#############################################################################

Feature: Actions on individual challenge page

Background:
    Given the user is at an individual challenge page
    
    Scenario: Emailing the individual challenge data
        Given the user clicks the link to email the challenge page data
        Then the users default email client opens a new email to compose
        And the challenge page data text is pasted into the new email draft
# TODO: More data likely needed here for definition

    Scenario: Posting a link to this challenge page on facebook
        Given the user clicks the link to post this challenge page to facebook
        Then the users facebook account is opened 
        And a draft post is created to post the challenge data and URL to their wall
# TODO: More data likely needed here for definition

    Scenario: Posting a link to this challenge page on twitter
        Given the user clicks the link to post this url to twitter
        Then the users twitter program is opened
        And a new tweet is drafted
        And the challenge title and URL is posted in the drafted tweet
# TODO: More data likely needed here for definition        
        
    Scenario: Return to the Challenge Index
        Given the user clicks the link to return to the challenge index
        Then the user is at the default challenge index page
        
# TODO: Resolve whether we go to the default page with noted caveats or one of possible challenge index pages
        
    Scenario: Individual challenge landing page to about us page
        Given the user clicks the link to the about us page
        Then the user is at the about us page
        
        
#############################################################################		
#                              NEW FEATURE                                  #
#############################################################################

@aggregate @front_end_user @about_us
Feature: Actions on the about us page

Background:
    Given the user is at the about us page
    
    Scenario: Move from the about us page to the challenge index page
        Given the user clicks the button to go to the challenge index page
        Then the user is at the default landing page
        
     Scenario: Message the admins
        Given the user clicks on link to message the site admins
        Then the users default email client opens a new email to compose
        And the site email address for front end user responses is pasted into the to field of the email
        
# TODO: More data likely needed here for definition
        
#############################################################################		
#                              NEW FEATURE                                  #
#############################################################################
	
@aggregate @front_end_user @challenge_index_page @pagination
Feature: Responses associated with pagination
	
	Scenario: Correct display of pagination
		Given the loaded database in use is "<db>"
		# Test dependent
		And the user is at challenge index page "<page_number>"
		And the previous button is "<prev_button>"  
		And the square 1 button is "<sq_1>"
		And the square 2 button is "<sq_2>"
		And the square 3 button is "<sq_3>"
		And the square 4 button is "<sq_4>"
		And the square 5 button is "<sq_5>"
		And the next button is "<next_button>"  
		Then the user clicks on the "<clicked_button>"
		And the user is at challenge index page "<new_page_number>"
		And the new square 1 button is "<new_sq_1>"
		And the new square 2 button is "<new_sq_2>"
		And the new square 3 button is "<new_sq_3>"
		And the new square 4 button is "<new_sq_4>"
		And the new square 5 button is "<new_sq_5>"
		
		Example: 
		    | db    | page_number   | prev_button   | sq_1      | sq_2      | sq_3      | sq_4      | sq_5      | next_button   | clicked_button    | new_page_number   | sq_1      | sq_2      | sq_3      | sq_4      | sq_5      |
		    | 1     | 1             | not_there     | there     |           | 
		
# TODO: Make better examples here when we learn more
# TEST NOTE: Make a step of the above

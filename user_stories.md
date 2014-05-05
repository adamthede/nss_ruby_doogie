User Stories
============

As a software developer
In order to keep a detailed journal of my day
I want a simple command line journalling app.
And I want to journal like Doogie Howser, M.D.

## Viewing the Menu

As someone that's unfamiliar with the application
I want to see a list of options so that I can
continue on.

Acceptance Criteria:
* If the user selects 1, they see "Add person."
* If the user selects 2, they see "Tell me a story."
* If the user selects 3, they see "Display 5 most recent entries."

Usage:

  `> ./doogie`

    What do you want to do?
    1. Add person.
    2. Tell me a story.
    3. Display 5 most recent entries.

## Add Person

Acceptance Criteria:

* Unique people will be added to the database
* Duplicate people can't be added

Usage:

  `> ./doogie`

    What do you want to do?
    1. Add person.
    2. Tell me a story.
    3. 5 most recent entries.
    - 1
    What is your name?
    - Adam Thede
    Welcome, Adam Thede.  You are now ready to journal like Doogie Howser, M.D.

## Add Journal Entry

Acceptance Criteria:

* Each journal entry shall be preceded by the date and an ellipsis.

Usage:

  `> ./doogie`

    What do you want to do?
    1. Add person.
    2. Tell me a story.
    3. Display 5 most recent entries.
    - 2
    Monday, May 5, 2014, 12:53PM ... right now I'm thinking pensively.

## Display Most Recent Entries

Acceptance Criteria:

* A numbered list will display the five most recent entries by date.
* The final list option will pull the next 5 entries.

Usage:

  `> ./doogie`

    What do you want to do?
    1. Add person.
    2. Tell me a story.
    3. Display 5 most recent entries.
    - 3
    1. Monday, May 5, 2014, 12:52PM ...
    2. Sunday, May 4, 2014, 9:15PM ...
    3. Saturday, May 3, 2014, 7:43AM ...
    4. Friday, May 2, 2014, 11:11PM ...
    5. Wednesday, April 30, 2014, 10:37PM ...
    6. Retrieve next 5 entries.

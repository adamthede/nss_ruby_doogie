require_relative '../spec_helper'
require_relative '../../models/journal'

describe "Menu Integration" do
  let(:menu_text) do
<<EOS
What do you want to do?
1. Add person.
2. Tell me a story.
3. Display 5 most recent entries.
4. Search for an entry by date.
5. Search all entries.
6. Display ALL entries.
7. Exit the app.
EOS
  end
  let(:doogie_typing) do
<<EOS
                    ___
                  /` ,-\/      _ ___
                  |_c  '>    |-|   |._
           ___     )_ _/     | |   |  |
          [___]   /  ``\____  | |   |_,.
          |  ^|  /  \/_____/) |-|___|
          |   | /    /   _:::_))_(___
          |   |/`-._/_   |___________|
          ``;_|\\____ ``\\||""""""""""||
            | `######|_|||          ||
            \ ._  _,'{~-_}|          ||
            _)   (  {-__}|          ||
           /______`\ |_,__)          ||

EOS
  end

  before do
    person = Person.new("Adam Thede")
    person.save
  end

  context "the menu displays on startup" do
    let(:shell_output){ run_doogie_with_input() }
    it "should print the main menu" do
      shell_output.should include(menu_text)
    end
  end

  context "the user selects 1" do
    let(:shell_output){ run_doogie_with_input("1") }
    it "should print the next menu" do
      shell_output.should include("What is your name?")
    end
  end

  context "the user selects 2" do
    let(:shell_output){ run_doogie_with_input("2") }
    it "should print the next menu" do
      shell_output.should include("What is your user name?")
    end
    let(:shell_output){ run_doogie_with_input("2", "Adam Thede") }
    it "should print the next menu" do
      shell_output.should include_in_order("What is your user name?", "Hi, Adam Thede!")
    end
  end

  context "the user selects 3" do
    before do
      Journal.new("sitting here working on tests").save
      Journal.new("still testing my menu integration").save
    end
    let(:shell_output){ run_doogie_with_input("3") }
    it "should print the next menu" do
      shell_output.should include("...")
      shell_output.should include("working on tests")
    end
  end

  context "the user selects 4" do
    let(:shell_output){ run_doogie_with_input("4") }
    it "should print the next option" do
      shell_output.should include("Please enter a date")
    end
  end

  context "the user selects 5" do
    let(:shell_output){ run_doogie_with_input("5") }
    it "should print the next option" do
      shell_output.should include("Please enter the text you would like to search for")
    end
  end

  context "the user selects 6" do
    let(:shell_output){ run_doogie_with_input("6") }
    before do
      Journal.new("sitting here working on tests").save
      Journal.new("still testing my menu integration").save
    end
    it "should display all entries" do
      shell_output.should include("sitting here working on tests")
      shell_output.should include("still testing my menu integration")
    end
  end

  context "the user selects 7" do
    let(:shell_output){ run_doogie_with_input("7") }
    it "should exit the app" do
      shell_output.should include("Thank you for using Doogie Howser, CLI. Have a great day!")
    end
  end

  context "the check_user method functions appropriately" do
    let(:shell_output){ run_doogie_with_input("2", "Adam Thede") }
    it "should allow a registered user to proceed" do
      shell_output.should include_in_order("What is your user name?", "Hi, Adam Thede!")
    end
    context "with an invalid user" do
      let(:shell_output){ run_doogie_with_input("2", "Eliza Brock") }
      it "should not allow the user to input a journal entry" do
        shell_output.should include_in_order("What is your user name?", "Sorry, you don't appear to be registered with Doogie Howser, CLI.  Please add yourself.")
      end
    end
  end

  context "the proceed? method should function appropriately" do
    let(:shell_output){ run_doogie_with_input("3") }
    it "should invoke the proceed method" do
      shell_output.should include("Return to Main Menu (y/n)?")
    end
  end

  context "prompt for correct input if user inputs incorrect selection" do
    let(:shell_output){ run_doogie_with_input("z") }
    it "should print the menu again" do
      shell_output.should include_in_order(menu_text, "z", menu_text)
    end
    it "should include an appropriate error message" do
      shell_output.should include("'z' is not a valid selection")
    end
  end

  context "if the user types in no input" do
    let(:shell_output){ run_doogie_with_input("") }
    it "should print the menu again" do
      shell_output.should include_in_order(menu_text, "", menu_text)
    end
    it "should include an appropriate error message" do
      shell_output.should include("'' is not a valid selection.")
    end
  end

  context "if the user types in incorrect input multiple times, it should allow correct input" do
    let(:shell_output){ run_doogie_with_input("z", "", "1") }
    it "should include the appropriate menu" do
      shell_output.should include("What is your name?")
    end
  end

end

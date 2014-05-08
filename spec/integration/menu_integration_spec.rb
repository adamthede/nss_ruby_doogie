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
EOS
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
      shell_output.should include("...")
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

require_relative '../spec_helper'

describe "Adding a journal entry" do
  before do
    journal = Journal.new("Sitting in class")
    journal.save
    person = Person.new("Adam Thede")
    person.save
  end

  context "adding a unique journal entry" do
    let!(:output){ run_doogie_with_input("2", "Adam Thede", "Today was a good day.") }
    it "should print a confirmation message" do
      output.should include("Your journal entry has been saved!")
      Journal.count.should == 2
    end
    it "should insert a new journal entry" do
      Journal.count.should == 2
    end
    it "should save the journal entry contents" do
      Journal.last.entry.should == "Today was a good day."
    end
  end

  context "entering a blank journal entry" do
    let(:output){ run_doogie_with_input("2", "Adam Thede", "") }
    it "should print an appropriate error message" do
      output.should include("Your entry doesn't include any letters!  Please type some actual words.")
    end
    it "should allow the user to try again" do
      menu_text = "Tell me a story."
      as_user = "What is your user name?"
      output.should include_in_order(menu_text, "Your entry doesn't include any letters!  Please type some actual words.", as_user)
    end
    it "shouldn't save a blank entry" do
      Journal.count.should == 1
    end

    context "trying again" do
      let!(:output){ run_doogie_with_input("2", "Adam Thede", "", "Adam Thede", "I learned a lot today.") }
      it "should save a non-blank entry" do
        Journal.last.entry.should == "I learned a lot today."
      end
      it "should insert a new journal entry" do
        Journal.count.should == 2
      end
      it "should print a success message at the end" do
        output.should include("Your journal entry has been saved!")
      end
    end
  end

  context "entering a journal entry without any alphabet characters" do
    let(:output){ run_doogie_with_input("2", "Adam Thede", "4*25") }
    it "should not save the journal entry" do
      Journal.count.should == 1
    end
    it "should print an error message" do
      output.should include("Your entry doesn't include any letters!  Please type some actual words.")
    end
    it "should allow the user to try again" do
      menu_text = "Tell me a story."
      as_user = "What is your user name?"
      output.should include_in_order(menu_text, "doesn't include any letters", as_user)
    end
  end

  context "displaying all journal entries" do
    before do
      entry1 = Journal.new("writing tests")
      entry1.save
      entry2 = Journal.new("still writing tests")
      entry2.save
    end
    let(:output){ run_doogie_with_input("6") }
    it "should display all of the journal entries in the db" do
      output.should include("Sitting in class")
      output.should include("writing tests")
      output.should include("still writing tests")
    end
  end
end

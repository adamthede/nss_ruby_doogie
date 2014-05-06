require_relative '../spec_helper'

describe "Adding a journal entry" do
  before do
    journal = Journal.new("Sitting in class")
    journal.save
  end

  context "adding a unique journal entry" do
    let(:output){ run_doogie_with_input("2", "Today was a good day.") }
    it "should print a confirmation message" do
      output.should include("Your journal entry has been saved!")
    end
    it "should insert a new journal entry" do
      Journal.count.should == 2
    end
    it "should save the journal entry contents" do
      Journal.last.entry.should == "Today was a good day."
    end
  end

  context "entering a blank journal entry" do
    let(:output){ run_doogie_with_input("2", "") }
    it "should print an appropriate error message" do
      output.should include("Your entry is blank!  Please type something.")
    end
    it "should allow the user to try again" do
      menu_text = "Tell me a story."
      output.should include_in_order(menu_text, "Your entry is blank!", menu_text)
    end
    it "shouldn't save a blank entry" do
      Journal.count.should == 1
    end

    context "trying again" do
      let(:output){ run_doogie_with_input("2", "", "I learned a lot today.") }
      it "should save a non-blank entry" do
        Journal.last.entry.should == "I learned a lot today."
      end
      it "should print a success message at the end" do
        output.should include("Your journal entry has been saved!")
      end
    end
  end

  context "entering a journal entry without any alphabet characters" do
    let(:output){ run_doogie_with_input("2", "4*25") }
    it "should not save the journal entry" do
      Journal.count.should == 1
    end
    it "should print an error message" do
      output.should include("'4*25' doesn't appear to be a valid journal entry, as it does not include any letters.")
    end
    it "should allow the user to try again" do
      menu_text "Tell me a story."
      output.should include_in_order(menu_text, "doesn't appear to be a valid", menu_text)
    end
  end
end

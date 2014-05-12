require_relative '../spec_helper'

describe "Adding a person" do
  before do
    person = Person.new("Eliza")
    person.save
  end

  context "adding a unique person" do
    let!(:output){ run_doogie_with_input("1", "John") }
    it "should print a successful confirmation message" do
      output.should include("Hi, John! Welcome to Doogie Howser, CLI")
      Person.count.should == 2
    end
    it "should insert a new person in the db" do
      Person.count.should == 2
    end
    it "should save the name we entered" do
      Person.last.name.should == "John"
    end
  end

  context "adding a duplicate person" do
    let(:output){ run_doogie_with_input("1", "Eliza") }
    it "should print an error message" do
      output.should include("Sorry, 'Eliza' already exists.")
    end
    it "should ask them to try again" do
      menu_text = "What is your name?"
      output.should include_in_order(menu_text, "already exists", menu_text)
    end
    it "shouldn't save the duplicate" do
      Person.count.should == 1
    end
    context "and trying again" do
      let!(:output){ run_doogie_with_input("1", "Eliza", "John") }
      it "should save a unique item" do
        Person.last.name.should == "John"
      end
      it "should print a success message at the end" do
        output.should include("Hi, John! Welcome to Doogie Howser, CLI")
      end
    end
  end

  context "entering an invalid looking person name" do
    context "without any alphabet characters" do
      let(:output){ run_doogie_with_input("1", "4***%45") }
      it "should not save the person" do
        Person.count.should == 1
      end
      it "should print an error message" do
        output.should include("You didn't include any letters!  Surely your name must have letters in it.")
      end
      it "should let them try again" do
        menu_text = "What is your name?"
        output.should include_in_order(menu_text, "didn't include any letters", menu_text)
      end
    end
  end
end

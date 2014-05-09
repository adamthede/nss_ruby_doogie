require_relative '../spec_helper'

require 'date'
require 'time'

describe Journal do
  context ".count" do
    context "with no journal entries in the database" do
      it "should return 0" do
        Journal.count.should == 0
      end
    end

    context "with multiple journal entries in the database" do
      before do
        Journal.new("Hello").save
        Journal.new("World").save
      end
      it "should return the correct count" do
        Journal.count.should == 2
      end
    end
  end

  context ".all" do
    context "with no journal entries in the db" do
      it "should return an empty array" do
        Journal.all.should be_an_instance_of Array
        Journal.all.should == []
      end
    end

    context "with journal entries in the db" do
      before do
        Journal.new("Hello").save
        Journal.new("World").save
      end
      it "should return an array of entries" do
        Journal.all.should be_an_instance_of Array
      end
      it "should return the correct entries" do
        entries = Journal.all.map(&:entry)
        entries.should == ["Hello", "World"]
      end
    end
  end

  context ".find_by_entry" do
    context "with no journal entries in the db" do
      it "should return 0" do
        Journal.find_by_entry("Hello world").should be_nil
      end
    end
    context "with entry by that name in the db" do
      before do
        Journal.new("Hello world").save
        Journal.new("Hello earth").save
      end
      it "should return the entry" do
        Journal.find_by_entry("Hello world").entry.should == "Hello world"
      end
    end
    context "with entry by partial search term" do
      before do
        Journal.new("Hello world").save
        Journal.new("Hello earth").save
      end
      it "should return the correct count" do
        Journal.find_by_entry("Hello").entry.should include("Hello")
      end
    end
  end

  context ".find_by_date" do
    context "with no journal entries in the db" do
      it "should return 0" do
        Journal.find_by_date(DateTime.now.to_s).should be_nil
      end
    end
    context "with an entry on the date in the db" do
      before do
        Journal.new("Hello World").save
        Journal.new("Hello Earth").save
      end
      it "should return the entry" do
        Journal.find_by_date(DateTime.now.to_s).entry.should == "Hello World"
      end
    end
  end

  context ".last" do
    context "with no journal entries in the database" do
      it "should return nil" do
        Journal.last.should be_nil
      end
    end

    context "with multiple journal entries in the database" do
      before do
        Journal.new("Hello").save
        Journal.new("World").save
      end
      it "should return the last journal entry inserted" do
        Journal.last.entry.should == "World"
      end
    end
  end

  context "#new" do
    let(:journal){ Journal.new("Hello world") }
    it "should store the entry" do
      journal.entry.should == "Hello world"
    end
  end

  context "#save" do
    let(:result){ Environment.database_connection.execute("SELECT entry FROM journal") }
    context "with a unique entry" do
      let(:journal){ Journal.new("Working on my tests.") }
      it "should return true" do
        journal.save.should be_true
      end

      it "should only save one row to the database" do
        journal.save
        result.count.should == 1
      end

      it "should actually save it to the database" do
        journal.save
        result[0]["entry"].should == "Working on my tests."
      end
    end

    context "with an invalid journal entry" do
      let(:journal){ Journal.new("Testing") }
      before do
        journal.stub(:valid?){ false }
      end
      it "should not save the journal entry to the db" do
        journal.save
        result.count.should == 0
      end
    end
  end

  context "#valid?" do
    let(:result){ Environment.database_connection.execute("SELECT * FROM journal") }
    context "after fixing the errors" do
      let(:journal){ Journal.new("123") }
      it "should return true" do
        journal.valid?.should be_false
        journal.entry == "123"
        journal.entry = "Whoops! Meant to write I love testing."
        journal.valid?.should be_true
      end
    end

    context "with a valid entry" do
      let(:journal){ Journal.new("I love testing.") }
      it "should return true for a valid entry" do
        journal.valid?.should be_true
      end
    end

    context "with an invalid journal entry" do
      let(:journal){ Journal.new("2234)))") }
      it "should return false" do
        journal.valid?.should be_false
      end
      it "should save and log an appropriate error message" do
        journal.valid?
        journal.errors.first.should == "Your entry doesn't include any letters!  Please type some actual words."
      end
    end
  end
end

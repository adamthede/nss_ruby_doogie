require_relative '../spec_helper'

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
        Journal.find_by_date("2014-05-08").should be_nil
      end
    end
    context "with an entry on the date in the db" do
      before do
        Journal.new("Hello World").save
        Journal.new("Hello Earth").save
      end
      it "should return the entry" do
        Journal.find_by_date("2014-05-08").entry.should == "Hello World"
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
  end
end

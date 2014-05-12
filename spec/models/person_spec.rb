require_relative '../spec_helper'

describe Person do
  context ".all" do
    context "with no people in the database" do
      it "should return an empty array" do
        Person.all.should == []
      end
    end

    context "with multiple people in the database" do
      before do
        Person.new("Adam").save
        Person.new("Sam").save
        Person.new("Robert").save
      end
      it "should return all of the people in the db" do
        names = Person.all.map(&:name)
        names.should == ["Adam", "Sam", "Robert"]
      end
    end
  end

  context ".count" do
    context "with no people in the database" do
      it "should return 0" do
        Person.count.should == 0
      end
    end

    context "with multiple people in the database" do
      before do
        Person.new("Adam").save
        Person.new("Sam").save
        Person.new("Robert").save
      end
      it "should return 3" do
        Person.count.should == 3
      end
    end
  end

  context ".find_by_name" do
    context "with no people in the database" do
      it "should return 0" do
        Person.find_by_name("Adam").should be_nil
      end
    end

    context "with person by that name in the database" do
      before do
        Person.new("Adam").save
        Person.new("Sam").save
        Person.new("Robert").save
      end
      it "should return Adam" do
        Person.find_by_name("Adam").name.should == "Adam"
      end
    end
  end

  context ".last" do
    context "with no people in the database" do
      it "should return nil" do
        Person.last.should be_nil
      end
    end

    context "with multiple people in the database" do
      before do
        Person.new("Adam").save
        Person.new("John").save
        Person.new("Tyler").save
      end
      it "should return the last person inserted in the database" do
        Person.last.name.should == "Tyler"
      end
    end
  end

  context "#new" do
    let(:person){ Person.new("Adam") }
    it "should store the name of the person" do
      person.name.should == "Adam"
    end
  end

  context "#save" do
    let(:result){ Environment.database_connection.execute("SELECT name FROM people") }
    let(:person){ Person.new("Eliza") }
    context "with a valid person" do
      before do
        person.stub(:valid?){ true }
      end
      it "should only save one row to the database" do
        person.save
        result.count.should == 1
      end
      it "should actually save it to the database" do
        person.save
        result[0]["name"].should == "Eliza"
      end
    end

    context "with an invalid person" do
      before do
        person.stub(:valid?){ false }
      end
      it "should not save a new person" do
        person.save
        result.count.should == 0
      end
    end
  end

  context "#valid?" do
    let(:result){ Environment.database_connection.execute("SELECT name FROM people") }
    context "after fixing the errors" do
      let(:person){ Person.new("222") }
      it "should return true" do
        person.valid?.should be_false
        person.name = "Vincent"
        person.valid?.should be_true
      end
    end

    context "with a unique name" do
      let(:person){ Person.new("Carmine") }
      it "should return true" do
        person.valid?.should be_true
      end
    end

    context "with an invalid name" do
      let(:person){ Person.new("888") }
      it "should return false" do
        person.valid?.should be_false
      end
      it "should save the error message" do
        person.valid?
        person.errors.first.should == "You didn't include any letters!  Surely your name must have letters in it."
      end
    end

    context "with a duplicate name" do
      let(:name){ "Vincent" }
      let(:person){ Person.new(name) }
      before do
        Person.new(name).save
      end
      it "should return false" do
        person.valid?.should be_false
      end
      it "should save the error message" do
        person.valid?
        person.errors.first.should == "Sorry, '#{name}' already exists."
      end
    end
  end
end

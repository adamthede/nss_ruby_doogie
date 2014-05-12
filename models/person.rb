class Person
  attr_reader :errors
  attr_reader :id
  attr_accessor :name

  def initialize(name)
    @name = name
  end

  def save
    if self.valid?
      statement = "INSERT INTO people (name) values (?);"
      Environment.database_connection.execute(statement, name)
      @id = Environment.database_connection.execute("SELECT last_insert_rowid();")[0][0]
      true
    else
      false
    end
  end

  def valid?
    @errors = []
    if !name.match /[a-zA-Z]/
      @errors << "You didn't include any letters!  Surely your name must have letters in it."
    end
    if Person.find_by_name(self.name)
      @errors << "Sorry, '#{self.name}' already exists."
    end
    @errors.empty?
  end

  def self.find_by_name(name)
    statement = "SELECT * FROM people WHERE name = ?;"
    result = execute_and_instantiate(statement, name)
    unless result.empty?
      result[0]
    end
  end

  def self.all
    statement = "SELECT * FROM people;"
    execute_and_instantiate(statement)
  end

  def self.count
    statement = "SELECT COUNT(*) FROM people;"
    result = Environment.database_connection.execute(statement)
    result[0][0]
  end

  def self.last
    statement = "SELECT * FROM people ORDER BY id DESC LIMIT(1);"
    result = execute_and_instantiate(statement)
    unless result.empty?
      result[0]
    end
  end

  private

  def self.execute_and_instantiate(statement, bind_vars = [])
    rows = Environment.database_connection.execute(statement, bind_vars)
    results = []
    rows.each do |row|
      results << Person.new(row["name"])
    end
    results
  end
end

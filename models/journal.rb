class Journal
  require 'date'
  require 'time'

  attr_reader :entry
  attr_reader :errors

  def initialize(entry)
    @entry = entry
    @errors = []
  end

  def save
    if self.entry == ""
      @errors << 'Your entry is blank!  Please type something.'
    # if Journal.find_by_entry(self.entry)
      # @errors << '#{self.entry} already exists.'
      false
    else
      statement = "INSERT INTO journal (entry) values ('#{entry}')"
      Environment.database_connection.execute(statement)
      true
    end
  end

  def self.find_by_entry(entry)
    statement = "SELECT * FROM journal WHERE entry == '#{entry}'"
    execute_and_instantiate(statement)
    # need to implement FTS with virtual table in order for this to work
    # statement = "SELECT * FROM journal WHERE entry MATCH '#{entry}'"
    # execute_and_instantiate(statement)
  end

  def self.find_by_date(date)
    search_beginning = (Date.parse(date) - 1).to_s
    search_end = (Date.parse(date) + 1).to_s
    statement = "SELECT * FROM journal WHERE datetime BETWEEN '#{search_beginning}' AND '#{search_end}'"
    execute_and_instantiate(statement)
  end

  def self.count
    statement = "SELECT COUNT(*) FROM journal"
    result = Environment.database_connection.execute(statement)
    result[0][0]
  end

  def self.last
    statement = "SELECT * FROM journal ORDER BY id DESC LIMIT(1)"
    execute_and_instantiate(statement)
  end

  private

  def self.execute_and_instantiate(statement)
    result = Environment.database_connection.execute(statement)
    unless result.empty?
      entry = result[0]["entry"]
      Journal.new(entry)
    end
  end

end

class Journal
  require 'date'
  require 'time'

  attr_accessor :entry
  attr_reader :datetime
  attr_reader :errors

  def initialize(entry, datetime= DateTime.now)
    @entry = entry
    @datetime = DateTime.parse(datetime.to_s)
    @errors = []
  end

  def save
    if self.valid?
      statement = "INSERT INTO journal (entry, datetime) VALUES ('#{entry}', '#{datetime}')"
      Environment.database_connection.execute(statement)
      true
    else
      false
    end
  end

  def self.find_by_entry(entry)
    statement = "SELECT * FROM journal WHERE entry LIKE '%#{entry}%'"
    result = execute_and_instantiate(statement)
    unless result.nil?
      entry = result[0]["entry"]
      datetime = result[0]["datetime"]
      Journal.new(entry, datetime)
    end
  end

  def self.find_by_date(date)
    search_beginning = (Date.parse(date) - 1).to_s
    search_end = (Date.parse(date) + 1).to_s
    statement = "SELECT * FROM journal WHERE datetime BETWEEN '#{search_beginning}' AND '#{search_end}'"
    result = execute_and_instantiate(statement)
    unless result.nil?
      entry = result[0]["entry"]
      datetime = result[0]["datetime"]
      Journal.new(entry, datetime)
    end
  end

  def self.count
    statement = "SELECT COUNT(*) FROM journal"
    result = Environment.database_connection.execute(statement)
    result[0][0]
  end

  def self.last
    statement = "SELECT * FROM journal ORDER BY id DESC LIMIT(1)"
    result = execute_and_instantiate(statement)
    unless result.nil?
      entry = result[0]["entry"]
      datetime = result[0]["datetime"]
      Journal.new(entry, datetime)
    end
  end

  def self.display_most_recent
    statement = "SELECT * FROM journal ORDER by datetime DESC LIMIT(5)"
    result = execute_and_instantiate(statement)
    if result.nil?
      puts "Sorry, no entries matched your search."
    else
      result.each do |entry|
        journal_entry = Journal.new(entry["entry"], entry["datetime"])
        puts journal_entry.datetime.strftime('%A, %B %d, %Y, %I:%M%p ... ') + " " + journal_entry.entry.to_s
      end
    end
  end

  def valid?
    @errors = []
    if !entry.match /[a-zA-Z]/
      @errors << "Your entry doesn't include any letters!  Please type some actual words."
    end
    @errors.empty?
  end

  private

  def self.execute_and_instantiate(statement)
    result = Environment.database_connection.execute(statement)
    unless result.empty?
      return result
    end
  end

end

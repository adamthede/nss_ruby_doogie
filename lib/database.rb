require 'sqlite3'

class Database < SQLite3::Database
  def initialize(database)
    super(database)
    self.results_as_hash = true
  end

  def self.connection(environment)
    @connection ||= Database.new("db/doogie_#{environment}.sqlite3")
  end

  def create_tables
    self.execute("CREATE TABLE journal (id INTEGER PRIMARY KEY AUTOINCREMENT, datetime DATETIME DEFAULT CURRENT_TIMESTAMP, entry TEXT NOT NULL)")
  end

  def execute(statement)
    Environment.logger.info("Executing: " + statement)
    super(statement)
  end
end

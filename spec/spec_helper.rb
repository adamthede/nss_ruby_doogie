require 'rspec/expectations'

$LOAD_PATH << "lib"
$LOAD_PATH << "models"

require 'environment'
require 'journal'
require 'person'

Environment.environment = "test"

def run_doogie_with_input(*inputs)
  shell_output = ""
  IO.popen('ENVIRONMENT=test ./doogie', 'r+') do |pipe|
    inputs.each do |input|
      pipe.puts input
    end
    pipe.close_write
    shell_output << pipe.read
  end
  shell_output
end

RSpec.configure do |config|
  config.after(:each) do
    Environment.database_connection.execute("DELETE FROM journal;")
    Environment.database_connection.execute("DELETE FROM people;")
  end
end

RSpec::Matchers.define :include_in_order do |*expected|
  match do |actual|
    input = actual.delete("\n")
    regexp_string = expected.join(".*").gsub("?","\\?").gsub("\n",".*")
    result = /#{regexp_string}/.match(input)
    result.should be
  end
end

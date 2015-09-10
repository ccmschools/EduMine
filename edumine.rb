# Author: 	Scott Willett
# Version: 	11:29 AM 8/09/2015
#
# Description: Run queries against your Edumate database
#
# Resources
# http://www.rubydoc.info/github/erikh/ruby-dbi/DBI 
# http://www.tutorialspoint.com/ruby/ruby_database_access.htm
# http://anthonylewis.com/2011/03/08/exploring-odbc-with-ruby-dbi/
# http://www.tutorialspoint.com/ruby/ruby_dbi_fetching_results.htm
# http://www.tutorialspoint.com/ruby/ruby_database_access.htm

# A module that interacts with the database
require_relative 'database.rb'
include Database

# Determines if the program is in command line interface mode. If it is, act like a CLI
cli = false

# Infinite loop if in CLI mode
loop do

	# Prompt for input if CLI mode is enabled, else use cmd arguments
	if cli
		print "> "
		input = gets.chomp
		input = input.scan(/\s+|\w+|"[^"]*"/).reject { |token| token =~ /^\s+$/ }.map { |token| token.sub(/^"/, "").sub(/"$/, "") }
	else
		input = ARGV
	end

	# Switchboard for the program based upon the first argument passed in
	case input[0]
		# Run an SQL query if the first arg is 'query'
		when 'query'
			Database.query(input[1])
		# View information about an SQL query if the first arg is 'query_info'
		when 'query_info'
			Database.query_info(input[1])
		# List all tables in the database, or specific columns in a table if specified with the 'tables' arg
		when 'tables'
			Database.tables(input[1..input.length])
		# Exit the program if 'exit' or 'quit' is typed
		when 'exit', 'quit'
			exit
		# Print help instructions from appropriate flags
		when 'readme', 'help', '?', '/?', '?'
			file = File.open("README.md")
			puts file.read
		else
			cli = true
	end
	
	# Exit the program if CLI isn't enabled
	break unless cli
end
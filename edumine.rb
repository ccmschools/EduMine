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

# Switchboard for the program
case ARGV[0]
	when 'query'
		Database.query(ARGV[1])
	when 'query_info'
		Database.query_info(ARGV[1])
	when 'tables'
		Database.tables(ARGV[1..ARGV.length])
	else
		file = File.open("README.md")
		puts file.read
end
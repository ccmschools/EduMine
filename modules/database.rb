# Author: 	Scott Willett
# Version: 	2:45 PM 8/09/2015

# Configuration file markup language
require_relative '../classes/config.rb'

# Functions that interact with the database are found here, along with a few helpers
module Database

	# To prevent error messages from the DBI gem (various constant initialization warnings)
	def suppress_warnings
		original_verbosity = $VERBOSE
		$VERBOSE = nil
		result = yield
		$VERBOSE = original_verbosity
		return result
	end

	# Connect to the database and suppress warning messages. Return the database connection object.
	def connect
		
		# Configuration class with login details to the database and the database driver
		config = EdumineConfig.new
	
		# Connect to the database and suppress warnings using the details from the configuration class. Return the result.
		suppress_warnings do
			require 'DBI' 
			# Create an ODBC connection instance using SequeLink_ODBC.
			return DBI.connect("DBI:ODBC:#{config.database_driver}", config.edumate_username, config.edumate_password)
		end
	end

	# Run a query. If the query variable matches a file name in the queries directory (prefixing the .sql extension), the contents of that file are a query)
	def query(query)
	
		# Connect to the database
		db_connection = connect
	
		# If there's an sql file matching the query param of this function, make the contents of that file the query
		if File.file?("queries\\#{query}.sql")
			file = File.open("queries\\#{query}.sql")
			query = file.read
		end
		
		# Execute the query with some error handling
		begin
			query_command = db_connection.prepare(query)
			query_command.execute
			query_data = query_command.fetch_all
			
			# Output the query result in CSV format
			puts query_data[0].column_names.join(", ")
			query_data.each do |row|
				puts row.to_a.join(", ")
			end
			
			# Dispose of the query object
			query_command.finish
			
		# Print an error if the query couldn't be run
		rescue DBI::DatabaseError => e
			 puts "An error occurred"
			 puts "Error message: #{e.errstr}"
			
		# Regardless on if the query could be run or not, disconnect from the database
		ensure
			 # disconnect from server
			 db_connection.disconnect if db_connection
		end
	end
	
	# Documentation for each query should be under the query_info directory in a text file
	def query_info(query)
	
		# If the query param matches the name of a text file in the query_info directory, output the info
		if File.file?("queries\\#{query}.txt")
			file = File.open("queries\\#{query}.txt")
			puts file.read
		else
			# If there's no query_info above, output an error
			puts "No info found at: queries\\#{query}.txt"
		end
	end
	
	# List all table names. An unlimited number of tables can be specified on the command line to obtain column_names for that table
	def tables(*tables)
	
		# Connect to the database
		db_connection = connect
	
		# If additional arguments are specified
		unless tables[0] == nil || tables[0].empty?
		
			# List the table and the columns for each table specified
			begin
				tables[0].each do |table|
					query_data = db_connection.select_all("SELECT * FROM #{table} fetch first 1 rows only")
					puts "#{table} #{query_data[0].column_names.join(', ')}\n\n"
				end
				
			# Output an error if the table / column_names couldn't be found
			rescue DBI::DatabaseError => e
				 puts "An error occurred"
				 puts "Error message: #{e.errstr}" 
			end
			
		# Output a list of tables if no tables are specified
		else
			puts db_connection.tables
		end
		
	end
	
end
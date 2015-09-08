# Author: 	Scott Willett
# Version: 	2:45 PM 8/09/2015

# Configuration file markup language
require_relative 'config.rb'

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
	
		config = EdumineConfig.new
	
		suppress_warnings do
			require 'DBI' 
			# Create an ODBC connection instance using SequeLink_ODBC.
			return DBI.connect("DBI:ODBC:#{config.database_driver}", config.edumate_username, config.edumate_password)
		end
	end

	# Run a query. If the query variable matches a file name in the queries directory (prefixing the .sql extension), the contents of that file are a query)
	def query(query)
	
		db_connection = connect
	
		if File.file?("queries\\#{query}.sql")
			file = File.open("queries\\#{query}.sql")
			query = file.read
		end
		
		begin
			query_command = db_connection.prepare(query)
			query_command.execute
			query_data = query_command.fetch_all
			
			puts query_data[0].column_names.join(", ")
			query_data.each do |row|
				puts row.to_a.join(", ")
			end
			
			query_command.finish
			
		rescue DBI::DatabaseError => e
			 puts "An error occurred"
			 puts "Error message: #{e.errstr}"
			 
		ensure
			 # disconnect from server
			 db_connection.disconnect if db_connection
		end
	end
	
	# Documentation for each query should be under the query_info directory in a text file
	def query_info(query)
		if File.file?("query_info\\#{query}.txt")
			file = File.open("query_info\\#{query}.txt")
			puts file.read
		else
			puts "No info found at: query_info\\#{query}.txt"
		end
	end
	
	# List all table names. An unlimited number of tables can be specified on the command line to obtain column_names for that table
	def tables(*tables)
	
		db_connection = connect
	
		unless tables[0] == nil || tables[0].empty?
		
			begin
				tables[0].each do |table|
					query_data = db_connection.select_all("SELECT * FROM #{table} fetch first 1 rows only")
					puts "#{table} #{query_data[0].column_names.join(', ')}\n\n"
				end
				
			rescue DBI::DatabaseError => e
				 puts "An error occurred"
				 puts "Error message: #{e.errstr}" 
			end
			
		else
			puts db_connection.tables
		end
		
	end
	
end
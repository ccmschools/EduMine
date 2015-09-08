
Edumine
=======

Description: 

	Allows you to run queries against your hosted Edumate database.
	
	All data is returned in a *.csv format which you can pipe into a file.
	
	You can run *.sql files against the database.
	
	There are some helpers to document your queries, 
	list tables in your database, and list specific tables and their columns.

Usage:

	Command Line Query:
		ruby edumine.rb query 'select * from table'

	Run a query from a file file (eg: file 'queries\test.sql')
		ruby edumine.rb query test
		
	Parse any output to a CSV file
		ruby edumine query test >> c:\mydirectory\myfile.csv
		
	View the details of a query file 
	(stored under the query_info directory eg: 'query_info\test.txt')
		ruby edumine.rb query_info test
	
	List all table names
		ruby edumine.rb tables
		
	List specific tables and their columns
		ruby edumine.rb tables table_1 table_2 table_3 ...
		
Setup instructions:

	Install ruby: http://rubyinstaller.org/

	To obtain access to your hosted Edumate database, you'll need to contact Hobsons 
	and obtain ODBC access permissions, details, and purchase an ODBC driver from 
	one of their partners (there's a 15 day trial on the driver).
	
	Once you have installed the SequeLink ODBC driver, you have to set 
	some environment variables.
	
	On Windows you can set these through the command line:
		setx EDUMATE_USERNAME <username>
		setx EDUMATE_PASSWORD <password>
		
	You'll then need to add a regkey to your database:
		HKEY_CURRENT_USER\Software\ODBC\ODBC.INI\SequeLink_ODBC
		DatabaseName	REG_SZ	<database_name>
		
	Run 'bundle install' from the EduMine directory to install ruby dependencies (gems)
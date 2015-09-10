# Author: 	Scott Willett
# Version: 	2:11 PM 10/09/2015

require 'yaml'	 # A library to interact with *.yml files, a neat configuration language

# Represents the configuration to connect to the Edumate databae
class EdumineConfig
	
	# All configurations have getters and setters
	attr_accessor :edumate_username, :edumate_password, :database_driver
	
	# Upon object creation, load the config.yml values into instance variables
	def initialize
		config_file = YAML.load_file('config.yml')
		@edumate_username = config_file['edumate_username']
		@edumate_password = config_file['edumate_password']
		@database_driver = config_file['database_driver']
	end
	
end
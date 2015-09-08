require 'yaml'

class EdumineConfig
	
	attr_accessor :edumate_username, :edumate_password, :database_driver
	
	def initialize
		config_file = YAML.load_file('config.yml')
		@edumate_username = config_file['edumate_username']
		@edumate_password = config_file['edumate_password']
		@database_driver = config_file['database_driver']
	end
	
end
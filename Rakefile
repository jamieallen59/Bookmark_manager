require 'data_mapper'
require './app/data_mapper_setup'

task :auto_upgrade do
	# auto_upgrade makes non-destrcutive changes.
	# If the tables don't exist, they are created,
	# but if they do, nothing will be upgraded as 
	# that would lead to data loss
	DataMapper.auto_upgrade!
	puts "Auto-upgrade complete (no data loss)"
end

task :auto_migrate do
	# To force the creation of your tables, even
	# if this leads to data loss, use auto_migrate:
	DataMapper.auto_migrate!
	puts "Auto-migrate complete (data could have been lost)"
end

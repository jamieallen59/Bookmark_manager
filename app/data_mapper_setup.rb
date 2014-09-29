env = ENV["RACK_ENV"] || "development"
# we're telling datamapper to use a postgres database on localhost. The name will be "bookmark_manager_test"
# So, we begin by telling datamapper where our database is going to be. The second argument to setup() is called a connection string. 
DataMapper.setup(:default, "postgres://localhost/bookmark_manager_#{env}")
# this needs to be done after datamapper is initialised
require './app/models/user'
require './app/models/tag'
require './app/models/link'
#After declaring your models, you should finalise them
DataMapper.finalize

#However, the database tables don't exist yet. Let's tell datamapper to create them

DataMapper.auto_upgrade!
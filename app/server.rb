require 'data_mapper'
require 'sinatra'
require './lib/link'
require './lib/tag'
require './lib/user'
require_relative './views/helpers/helpers'
require_relative 'data_mapper_setup'

enable :sessions
set :session_secret, 'super secret'

helpers do
	def current_user
		@current_user ||=User.get(session[:user_id]) if session[:user_id]
	end
end

get '/' do
	@links = Link.all
	erb :index
end

post '/links' do
	url = params["url"]
	title = params["title"]
	tags = params["tags"].split(" ").map do |tag|
		Tag.first_or_create(:text => tag)
		#this will either find this tag or create
		#it, if it doesn't exist already
	end
	Link.create(:url => url, :title => title, :tags => tags) 
	redirect to('/')
end

get '/tags/:text' do
	tag = Tag.first(:text => params[:text])
	@links = tag ? tag.links : []
	erb :index
end

get '/users/new' do
	# note the view is in views/users/new.erb
	# we need the quotes because otherwise
	#ruby would divide the symbol :users by the
	# variable new (which makes no sense)
	erb :"users/new"
end

post '/users' do
	user = User.create(:email => params[:email],
				:password => params[:password],
				:password_confirmation => params[:password_confirmation])
	session[:user_id] = user.id
	redirect to('/')
end




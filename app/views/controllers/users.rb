# require 'sinatra'

get '/users/new' do
	# note the view is in views/users/new.erb
	# we need the quotes because otherwise
	#ruby would divide the symbol :users by the
	# variable new (which makes no sense)
	@user = User.new
	erb :"users/new"
end

post '/users' do
	@user = User.create(:email => params[:email],
				:password => params[:password],
				:password_confirmation => params[:password_confirmation])
	if @user.save
		session[:user_id] = @user.id
		redirect to('/')
		# if it's not valid, we'll show
		# the same form again
	else
		flash.now[:errors] = @user.errors.full_messages
		erb :"users/new"
	end
end

get '/users/forgot_password' do
	erb :"users/forgot_password"
end

post '/users/forgot_password' do
	email = params[:email]
	user = User.first(email: email)
	token = create_new_token
	user.update(password_token: token,
		        password_token_timestamp: create_new_timestamp)
	send_password email, token
	erb :"sessions/check_email"
end

get '/users/forgot_password/:password_token' do
	@token = params[:password_token]
	# user = User.first(password_token: token)
	erb :"users/reset_password"
end

post '/users/reset_password' do
	password = params[:password]
	password_confirmation = params[:password_confirmation]
	user = User.first(:password_token => params[:token])
	user.update(:password => password,
		        :password_confirmation => password_confirmation)
	erb :"sessions/new"
end

def send_password email, token
	RestClient.post "https://api:key-48-4tk8wpb9hjja9ty1b0-cmkkglo062"\
	"@api.mailgun.net/v2/app27948375.mailgun.org/messages",
	from: 'Excited User <me@app27948375.mailgun.org>',
  to: email,
  subject: 'New password',
  text: create_link_with(token)
end


def create_link_with token
	"http://localhost:9292/users/forgot_password/" + token.to_s
end


def create_new_token
	(1..64).map{ ('A'..'Z').to_a.sample }.join
end

def create_new_timestamp
	Time.now
end





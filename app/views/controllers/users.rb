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
	erb :forgot_password
end

post '/users/forgot_password' do
	email = params[:email]
	user = User.first(:email => email)
	user.password_token = (1..64).map{ ('A'..'Z').to_a.sample }.join
	user.password_token_timestamp = Time.now
	user.save
end

get '/users/forgot_password/:token' do
	token = params[:token]
	user = User.first(:email => email)
end

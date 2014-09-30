require 'spec_helper'
require_relative 'helpers/session'

include SessionHelpers

feature "User signs up" do

	scenario "with a password that doesn't match" do
		expect(lambda { sign_up('a@a.com', 'pass', 'wrong') }).to change(User, :count).by(0)
		expect(current_path).to eq('/users')
		expect(page).to have_content("Sorry, your passwords don't match")
	end

	scenario "with an email that is already registered" do
		expect(lambda { sign_up }).to change(User, :count).by(1)
		expect(lambda { sign_up }).to change(User, :count).by(0)
		expect(page).to have_content("This email is already taken")
	end

	# Strictly speaking, the tests that check the UI
	# (have_content, etc.) should be separate from the tests
	# that check what we have in the DB. The reason is that
	# you should test one thing at a time, whereas
	# by mixing the two we're testing both
	# the business logic and the views.
	
	scenario "when being logged out" do
		expect(lambda { sign_up }).to change(User, :count).by(1)
		expect(page).to have_content("Welcome, alice@example.com")
		expect(User.first.email).to eq("alice@example.com")
	end

end

feature "User signs in" do

	before(:each) do
		User.create(:email => "test@test.com",
					:password => 'test',
					:password_confirmation => 'test')
	end

	scenario "with correct credentials" do
		visit '/'
		expect(page).not_to have_content("Welcome, test@test.com")
		sign_in('test@test.com', 'test')
		expect(page).to have_content("Welcome, test@test.com")
	end

	scenario "with incorrect credentials" do
		visit '/'
		expect(page).not_to have_content("Welcome, test@test.com")
		sign_in('test@test.com', 'wrong')
		expect(page).not_to have_content("Welcome, test@test.com")
	end

end

feature 'User signs out' do

	before(:each) do
		User.create(:email => "test@test.com",
					:password => 'test',
					:password_confirmation => 'test')
	end

	scenario 'while being signed in' do
		sign_in('test@test.com', 'test')
		click_button "Sign out"
		expect(page).to have_content("Good bye!") # where does this message go?
		expect(page).not_to have_content("welcome, test@test.com")
	end
end

feature 'User has forgotten password' do

	scenario 'presses forgot password button' do
		visit '/sessions/new'
		click_link "Forgot password"
		expect(page).to have_content("Enter your email address")
	end

	# scenario 'enters email to get password recovery token' do
	# 	visit'/users/forgot_password'
	# 	fill_in 'email' :with => "test@test.com"
	# 	click_button 'Get code!'
	# 	expect("EMAIL SENT TO USER WITH CODE")
	# end
end







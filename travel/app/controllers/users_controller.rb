class UsersController < ApplicationController
  register Sinatra::Flash
  require 'sinatra/flash'
  enable :sessions

  get '/signup' do 
      !logged_in? ? (erb :'/users/signup') : (redirect "/")
  end 

  post '/signup' do
      user = User.create(:username => params[:username], :email => params[:email], :password => params[:password])
      if user.save 
          (session[:user_id] = user.id)
          (redirect "/destinations") 
      else
          flash[:error] = "Something went wrong. Please try again!"
          redirect "/signup"
      end
  end

  get '/login' do
      user = User.find_by(:username => params[:username])
      !logged_in? ? (erb :'/users/login') : (redirect "/destinations")
  end

  post "/login" do
      user = User.find_by(:username => params[:username])
      if user && user.authenticate(params[:password])
          session[:user_id] = user.id
          redirect "/destinations"
      else
          flash[:error] = "Incorrect username or password. Please try again!"
          redirect "/login"
      end
  end

  get "/logout" do
      if logged_in? 
          session.destroy
          redirect '/login' 
      else
          flash[:error] = "Something went wrong. Please try again!"
          redirect "/"
      end
  end

end
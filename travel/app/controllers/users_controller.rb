class UsersController < ApplicationController
  get '/signup' do
    redirect to '/destinations' if is_logged_in?

    erb :"users/signup"
  end

  post '/signup' do
    user_info = { :username => params["name"],
                  :email => params["email"],
                  :password => params["password"] }


    if User.find_by(:email => user_info[:email])
      flash[:account_taken] = "The email you provided is already in our system. Please enter a new email or log in to continue."
      redirect to '/signup'
    end

    new_user = User.create(user_info)
    session[:user_id] = new_user.id

    redirect to '/destinations'
  end

  get '/login' do
    redirect to '/destinations' if is_logged_in?

    erb :"users/login"
  end

  post '/login' do
    user_info = {
      :email => params["email"],
      :password => params["password"]
    }


    user = User.find_by(:email => user_info[:email])

    if user && user.authenticate(user_info[:password])
      session[:user_id] = user.id
      redirect to '/destinations'
    else
      if user
        flash[:password] = "Your password is incorrect"
        redirect to '/login'
      else
        flash[:no_account] = "There is no account associated with that email address. Please enter a different email or sign up for an account."
        redirect to '/login'
      end
    end
  end

  get '/logout' do
    if is_logged_in?
      session.clear
      redirect to '/login'
    else
      redirect to '/'
    end
  end
end
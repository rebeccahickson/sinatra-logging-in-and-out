require_relative '../../config/environment'
class ApplicationController < Sinatra::Base
  configure do
    set :views, Proc.new { File.join(root, "../views/") }
    enable :sessions unless test?
    set :session_secret, "secret"
  end

  get '/' do
    erb :index
  end

  post '/login' do
    u = User.find_by(username: params[:username], password: params[:password])
    if u.nil?
      erb :error
    else
      @session = session
      @session[:user_id] = u.id
      redirect '/account'
    end
  end

  get '/account' do
    @session = session
    if Helpers.is_logged_in?(@session)
      @user = User.find_by(id: @session[:user_id])
      erb :account
    else
      erb :error
    end
  end

  get '/logout' do
    session.clear
    redirect '/'
  end


end

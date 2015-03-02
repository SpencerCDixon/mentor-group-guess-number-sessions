require 'sinatra'
require 'dotenv'
require 'pry'

Dotenv.load # Load environment variables from the .env

use Rack::Session::Cookie, {
  secret: ENV["SESSION_SECRET"],
  expire_after: 86400 # seconds
}

def set_number
  rand(11)
end

correct_num = set_number

get '/' do
  session[:correct] = correct_num

  erb :home
end

post '/guess' do
  guess = params["guess"].to_i

  binding.pry

  if guess == session[:correct]
    session[:result] = "You win!"
    session[:correct] = set_number # reset correct number
  elsif guess > session[:correct]
    session[:result] = "Too High!"
  elsif guess < session[:correct]
    session[:result] = "Too Low!"
  end

  redirect '/'
end

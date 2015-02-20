require 'sinatra'
require 'json'

get '/' do
  redirect 'http://leanpoker.org'
end

get '/check' do
  JSON.generate :success => true
end

get '/deployment' do

end

get '/deployment/:id' do

end

post '/deployment' do

end

patch '/deployment/:id' do

end

delete '/deployment/:id' do

end
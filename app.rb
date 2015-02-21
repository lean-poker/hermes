require 'sinatra'
require 'json'
require_relative 'bootstrap'
require_relative 'lib/lean_poker_hermes'

get '/' do
  redirect 'http://leanpoker.org'
end

get '/check' do
  JSON.generate :success => true
end

post '/check' do
  p params
  JSON.generate :success => true
end

post '/deployment' do
  LeanPokerHermes::Workers::Create.perform_async(params[:callback_url])
end

patch '/deployment/:id' do
  LeanPokerHermes::Workers::Deploy.perform_async(params[:id], params[:owner], params[:repository], params[:commit], params[:callback_url])
end

delete '/deployment/:id' do

end
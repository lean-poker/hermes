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
  env_vars = JSON.parse(params[:environment_variables])
  LeanPokerHermes::Workers::Create.perform_async(params[:callback_url],params[:buildpack], env_vars)
  JSON.generate :success => true
end

patch '/deployment/:id' do
  LeanPokerHermes::Workers::Deploy.perform_async(params[:id], params[:owner], params[:repository], params[:commit], params[:callback_url])
  JSON.generate :success => true
end

post '/deployment/:id/log_drain' do
  p "Adding log drain for #{params[:id]} with url #{params[:url]}"
  id = LeanPokerHermes::HerokuGateway.instance.add_log_drain(params[:id], params[:url])
  JSON.generate({:success => true, :id => id})
end

delete '/deployment/:id/log_drain/:drain_id' do
  LeanPokerHermes::HerokuGateway.instance.delete_log_drain(params[:id], params[:drain_id])
  JSON.generate :success => true
end

delete '/deployment/:id' do
  LeanPokerHermes::Workers::Delete.perform_async(params[:id])
  JSON.generate :success => true
end

get '/deployment/:id/config_var' do
  JSON.generate LeanPokerHermes::HerokuGateway.instance.get_config_vars(params[:id])
end

patch '/deployment/:id/config_var' do
  JSON.generate LeanPokerHermes::HerokuGateway.instance.set_config_vars(params[:id], JSON.parse(params[:config_vars]))
end

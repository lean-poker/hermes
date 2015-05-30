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
  halt 401 unless params[:token] == ENV['TOKEN']
  env_vars = nil
  env_vars = JSON.parse(params[:environment_variables]) unless params[:environment_variables].nil?
  LeanPokerHermes::Workers::Create.perform_async(params[:callback_url],params[:buildpack], env_vars)
  JSON.generate :success => true
end

patch '/deployment/:id' do
  halt 401 unless params[:token] == ENV['TOKEN']
  LeanPokerHermes::Workers::Deploy.perform_async(params[:id], params[:owner], params[:repository], params[:commit], params[:callback_url])
  JSON.generate :success => true
end

post '/deployment/:id/log_drain' do
  halt 401 unless params[:token] == ENV['TOKEN']
  puts "Adding log drain for #{params[:id]} with url #{params[:url]}"
  id = LeanPokerHermes::HerokuGateway.instance.add_log_drain(params[:id], params[:url])
  JSON.generate({:success => true, :id => id})
end

delete '/deployment/:id/log_drain/:drain_id' do
  halt 401 unless params[:token] == ENV['TOKEN']
  LeanPokerHermes::HerokuGateway.instance.delete_log_drain(params[:id], params[:drain_id])
  JSON.generate :success => true
end

delete '/deployment/:id' do
  halt 401 unless params[:token] == ENV['TOKEN']
  LeanPokerHermes::Workers::Delete.perform_async(params[:id])
  JSON.generate :success => true
end

get '/deployment/:id/config_var' do
  halt 401 unless params[:token] == ENV['TOKEN']
  JSON.generate LeanPokerHermes::HerokuGateway.instance.get_config_vars(params[:id])
end

patch '/deployment/:id/config_var' do
  halt 401 unless params[:token] == ENV['TOKEN']
  JSON.generate LeanPokerHermes::HerokuGateway.instance.set_config_vars(params[:id], JSON.parse(params[:config_vars]))
end

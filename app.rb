require 'sinatra'
require 'json'
require_relative 'bootstrap'
require_relative 'lib/lean_poker_hermes'

helpers do
  def authenticate(token, target_heroku_api_key)
    if token != ENV['TOKEN'] && target_heroku_api_key.nil?
      if !token.nil?
        puts "Authentication failed with token"
      elsif !target_heroku_api_key.nil?
        puts "Authentication failed with heroku key"
      else
        puts "No credentials were provided"
      end

      halt 401
    end
  end
end

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
  authenticate(params[:token], params[:target_heroku_api_key])
  env_vars = nil
  env_vars = JSON.parse(params[:environment_variables]) unless params[:environment_variables].nil?
  LeanPokerHermes::Workers::Create.perform_async(params[:callback_url],params[:buildpack], env_vars, params[:target_heroku_api_key])
  JSON.generate :success => true
end

patch '/deployment/:id' do
  authenticate(params[:token], params[:target_heroku_api_key])
  LeanPokerHermes::Workers::Deploy.perform_async(params[:id], params[:owner], params[:repository], params[:commit], params[:callback_url], params[:target_heroku_api_key])
  JSON.generate :success => true
end

post '/deployment/:id/log_drain' do
  authenticate(params[:token], params[:target_heroku_api_key])
  puts "Adding log drain for #{params[:id]} with url #{params[:url]}"
  id = LeanPokerHermes::HerokuGateway.instance(params[:target_heroku_api_key]).add_log_drain(params[:id], params[:url])
  JSON.generate({:success => true, :id => id})
end

delete '/deployment/:id/log_drain/:drain_id' do
  authenticate(params[:token], params[:target_heroku_api_key])
  LeanPokerHermes::HerokuGateway.instance(params[:target_heroku_api_key]).delete_log_drain(params[:id], params[:drain_id])
  JSON.generate :success => true
end

delete '/deployment/:id' do
  authenticate(params[:token], params[:target_heroku_api_key])
  LeanPokerHermes::Workers::Delete.perform_async(params[:id], params[:target_heroku_api_key])
  JSON.generate :success => true
end

get '/deployment/:id/config_var' do
  authenticate(params[:token], params[:target_heroku_api_key])
  JSON.generate LeanPokerHermes::HerokuGateway.instance(params[:target_heroku_api_key]).get_config_vars(params[:id])
end

patch '/deployment/:id/config_var' do
  authenticate(params[:token], params[:target_heroku_api_key])
  JSON.generate LeanPokerHermes::HerokuGateway.instance(params[:target_heroku_api_key]).set_config_vars(params[:id], JSON.parse(params[:config_vars]))
end

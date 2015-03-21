require 'sinatra'
require 'json'
require_relative 'bootstrap'
require_relative 'lib/lean_poker_hermes'
require_relative 'lib/document_store'

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
  JSON.generate :success => true
end

patch '/deployment/:id' do
  search_for = {id: params[:id], owner: params[:owner], repository: params[:repository]}
  deployment_data = {
      id: params[:id],
      owner: params[:owner],
      repository: params[:repository],
      commit: params[:commit],
      callback_url: params[:callback_url]
  }

  DocumentStore['deploys'].update(search_for, {'$set' => deployment_data}, upsert: true)
  JSON.generate :success => true
end

post '/deployment/:id/log_drain' do
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



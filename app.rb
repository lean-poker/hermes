require 'sinatra'
require 'json'

get '/check' do
  JSON.generate :success => true
end
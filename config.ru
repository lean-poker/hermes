require_relative 'app'
require 'sidekiq/web'

map '/' do
  run Sinatra::Application
end

map '/sidekiq' do
  run Sidekiq::Web
end
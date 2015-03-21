require 'dotenv'
require 'platform-api'
require 'sidekiq'
require_relative 'lib/lean_poker_hermes'
require_relative 'lib/http_request_light'
require_relative 'lib/document_store'

Dotenv.load

DocumentStore.connect ENV['MONGOLAB_API']

Sidekiq.configure_client do |config|
  config.redis = {
      :url => ENV['REDIS_URL'],
      :namespace => 'LeanPokerHermes'
  }
end

Sidekiq.configure_server do |config|
  config.redis = {
      :url => ENV['REDIS_URL'],
      :namespace => 'LeanPokerHermes'
  }
end

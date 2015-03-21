require 'dotenv'
require 'platform-api'
require 'sidekiq'
require_relative 'lib/lean_poker_hermes'
require_relative 'lib/http_request_light'

Dotenv.load

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

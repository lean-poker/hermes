require 'dotenv'
require 'platform-api'
require 'sidekiq'
require_relative 'lib/lean_poker_hermes'

Dotenv.load

Sidekiq.configure_client do |config|
  config.redis = {
      :url => ENV['REDISCLOUD_URL'],
      :namespace => 'LeanPokerHermes'
  }
end

Sidekiq.configure_server do |config|
  config.redis = {
      :url => ENV['REDISCLOUD_URL'],
      :namespace => 'LeanPokerHermes'
  }
end

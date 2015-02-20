require 'dotenv'
require 'platform-api'
require 'sidekiq'
require_relative 'lib/lean_poker_hermes'

Dotenv.load

DocumentStore.connect TournamentOrganizer::Config['MONGO_URL']

Sidekiq.configure_client do |config|
  config.redis = {
      :url => TournamentOrganizer::Config['REDIS_URL'],
      :namespace => 'LeanPokerHermes'
  }
end

Sidekiq.configure_server do |config|
  config.redis = {
      :url => TournamentOrganizer::Config['REDIS_URL'],
      :namespace => 'LeanPokerHermes'
  }
end

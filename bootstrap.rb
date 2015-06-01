require 'dotenv'
require 'platform-api'
require 'sidekiq'
require_relative 'lib/lean_poker_hermes'
require_relative 'lib/http_request_light'

require 'autoscaler/sidekiq'
require 'autoscaler/heroku_scaler'

Dotenv.load

Sidekiq.configure_client do |config|
  config.redis = {
      :url => ENV['REDIS_URL'],
      :namespace => 'LeanPokerHermes'
  }

  unless ENV['  HEROKU_API_KEY'].empty?
    config.client_middleware do |chain|
      chain.add Autoscaler::Sidekiq::Client, 'default' => Autoscaler::HerokuScaler.new
    end
  end
end

Sidekiq.configure_server do |config|
  config.redis = {
      :url => ENV['REDIS_URL'],
      :namespace => 'LeanPokerHermes'
  }

  unless ENV['HEROKU_API_KEY'].empty?
    config.server_middleware do |chain|
      chain.add(Autoscaler::Sidekiq::Server, Autoscaler::HerokuScaler.new, 240) # 240 second timeout
    end
  end
end

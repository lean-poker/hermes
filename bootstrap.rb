require "dotenv"
require "platform-api"
require "sidekiq"
require_relative "lib/lean_poker_hermes"

Dotenv.load

# Callback payloads are problematic.
# Probably because of the logs.
Sidekiq.strict_args!(false)

Sidekiq.configure_client do |config|
  config.redis = {
    url: ENV["REDISCLOUD_URL"]
  }
end

Sidekiq.configure_server do |config|
  config.redis = {
    url: ENV["REDISCLOUD_URL"]
  }
end

# Disable Strict Args checking
# https://github.com/sidekiq/sidekiq/wiki/Best-Practices
Sidekiq.strict_args!(false)
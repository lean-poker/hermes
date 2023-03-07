require "sentry-ruby"
require "sidekiq/web"
require "securerandom"
require_relative "app"

Sentry.init do |config|
  config.dsn = ENV["SENTRY_DSN"]
end

File.open(".session.key", "w") {|f| f.write(SecureRandom.hex(32)) }

map '/' do
  run Sinatra::Application
end

map '/sidekiq' do
  use Rack::Session::Cookie, secret: File.read(".session.key"), same_site: true, max_age: 86400
  run Sidekiq::Web
end
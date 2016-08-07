require 'sidekiq'
require 'faraday'

class LeanPokerHermes::Workers::RespondToCallback
  include Sidekiq::Worker

  def perform(callback_url, data)
    p "Sending response to #{callback_url}"
    result = Faraday.post(callback_url, data)
    raise Exception.new("Failed to respond through callback url") unless result.success?
  end
end
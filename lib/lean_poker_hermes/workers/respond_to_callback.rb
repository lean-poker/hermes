require "httparty"
require "sidekiq"

class LeanPokerHermes::Workers::RespondToCallback
  include Sidekiq::Job

  def perform(callback_url, data)
    p "Sending response to #{callback_url}"

    response = HTTParty.post callback_url, body: data, format: :plain
    json = JSON.parse response.body, symbolize_names: true
    raise StandardError.new("Failed to respond through callback url") unless json[:success]
  end
end

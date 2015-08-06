require 'sidekiq'

class LeanPokerHermes::Workers::Delete
  include Sidekiq::Worker

  def perform(id, target_heroku_api_key)
    LeanPokerHermes::HerokuGateway.instance(target_heroku_api_key).delete(id)
  end
end
require 'sidekiq'

class LeanPokerHermes::Workers::Delete
  include Sidekiq::Worker

  def perform(id)
    LeanPokerHermes::HerokuGateway.instance.delete(id)
  end
end
$:.push(File.join(File.dirname(__FILE__)))

module LeanPokerHermes
  autoload :Workers, 'lean_poker_hermes/workers'
  autoload :HerokuGateway, 'lean_poker_hermes/heroku_gateway'
end
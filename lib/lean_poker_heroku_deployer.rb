$:.push(File.join(File.dirname(__FILE__)))

module LeanPokerHerokuDeployer
  autoload :HerokuGateway, 'lean_poker_heroku_deployer/heroku_gateway'
end
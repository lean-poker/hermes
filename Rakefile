require_relative 'bootstrap'


task :create, :name do |_, args|
  app = LeanPokerHerokuDeployer::HerokuGateway.instance.create(args.name)
  p "Name: #{app['name']}, Id: #{app['id']}"
end

task :delete, :name do |_, args|
  LeanPokerHerokuDeployer::HerokuGateway.instance.delete(args.name)
end

task :deploy, :name, :repository, :commit do |_, args|
  # e9cbb9497e36883ef5f6e16b8fa9c4ead3fbc0ec
  LeanPokerHerokuDeployer::HerokuGateway.instance.deploy(args.name, args.repository, args.commit)
end
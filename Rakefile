require_relative 'bootstrap'


task :create do
  app = LeanPokerHermes::HerokuGateway.instance.create
  p "Name: #{app['name']}, Id: #{app['id']}"
end

task :delete, :name do |_, args|
  LeanPokerHermes::HerokuGateway.instance.delete(args.name)
end

task :deploy, :name, :repository, :commit do |_, args|
  LeanPokerHermes::HerokuGateway.instance.deploy(args.name, args.repository, args.commit)
end
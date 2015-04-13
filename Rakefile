require_relative 'bootstrap'


task :create do
  app = LeanPokerHermes::HerokuGateway.instance.create
  p "Name: #{app['name']}, Id: #{app['id']}"
end

task :delete, :name do |_, args|
  LeanPokerHermes::HerokuGateway.instance.delete(args.name)
end

task :deploy, :name, :owner, :repository, :commit do |_, args|
  deploy = LeanPokerHermes::HerokuGateway.instance.deploy(args.name, args.owner, args.repository, args.commit)

  begin
    print '.'
    STDOUT.flush
    info = LeanPokerHermes::HerokuGateway.instance.deployment_result(args.name,deploy['id'])
    sleep 1
  end while info["build"]["status"] == 'pending'

  info['lines'].map do |line|
    line['line']
  end
end

task :add_log_drain, :name, :url do |_, args|
  p LeanPokerHermes::HerokuGateway.instance.add_log_drain(args.name, args.url)
end

task :delete_log_drain, :name, :id do |_, args|
  LeanPokerHermes::HerokuGateway.instance.delete_log_drain(args.name, args.id)
end

task :get_config_vars, :name do |_, args|
  p LeanPokerHermes::HerokuGateway.instance.get_config_vars(args.name)
end

task :set_config_vars, :name, :config_vars do |_, args|
  LeanPokerHermes::HerokuGateway.instance.set_config_vars(args.name, JSON.parse(args.config_vars))
end
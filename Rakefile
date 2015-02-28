require_relative 'bootstrap'


task :create do
  app = LeanPokerHermes::HerokuGateway.instance.create
  p "Name: #{app['name']}, Id: #{app['id']}"
end

task :add_log_drain, :name, :url do |_, args|
  LeanPokerHermes::HerokuGateway.instance.add_log_drain(args.name, args.url)
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
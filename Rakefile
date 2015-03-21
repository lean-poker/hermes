require_relative 'bootstrap'


task :create do
  app = LeanPokerHermes::HerokuGateway.instance.create
  p "Name: #{app['name']}, Id: #{app['id']}"
end

task :add_log_drain, :name, :url do |_, args|
  p LeanPokerHermes::HerokuGateway.instance.add_log_drain(args.name, args.url)
end

task :delete_log_drain, :name, :id do |_, args|
  LeanPokerHermes::HerokuGateway.instance.delete_log_drain(args.name, args.id)
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

task :perform_deployments do
  DocumentStore['deploys'].find.each do |deploy|
    LeanPokerHermes::Workers::Deploy.perform_async(deploy[:id], deploy[:owner], deploy[:repository], deploy[:commit], deploy[:callback_url])
  end
end
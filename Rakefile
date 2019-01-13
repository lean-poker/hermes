require_relative 'bootstrap'
require 'faraday'


task :create do
  app = LeanPokerHermes::HerokuGateway.instance.create
  p "Name: #{app['name']}, Id: #{app['id']}"
end

task :list do
  LeanPokerHermes::HerokuGateway.instance.list.each do |app|
    puts app['name']
  end
end

task :delete, :name do |_, args|
  LeanPokerHermes::HerokuGateway.instance.delete(args.name)
end

task :deploy, :name, :archive_url, :commit do |_, args|
  deploy = LeanPokerHermes::HerokuGateway.instance.deploy(args.name, args.archive_url, args.commit)

  log_url = deploy['output_stream_url']

  puts log_url

  begin
    sleep 2
    print '.'
    STDOUT.flush
    info = LeanPokerHermes::HerokuGateway.instance.deployment_info(args.name,deploy['id'])

  end while info["status"] == 'pending'

  puts JSON.generate info["status"]
  puts ' --- '

  log_lines = Faraday.get(log_url).body

  print log_lines

  puts ' --- '
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
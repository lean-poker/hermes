require 'sidekiq'

class LeanPokerHermes::Workers::Create
  include Sidekiq::Worker

  def perform(callback_url, buildpack = nil)
    app = LeanPokerHermes::HerokuGateway.instance.create

    begin
      unless buildpack.nil?
        LeanPokerHermes::HerokuGateway.instance.set_buildpack(app['id'], buildpack)
      end
    rescue Exception => e
      puts "Could not set buildpack url!"
      puts e.message
    end

    app_info = {
        :id => app['id'],
        :name => app['name'],
        :url => "http://#{app['name']}.herokuapp.com/"
    }

    puts "Sending response to #{callback_url}"
    HttpRequestLight.post(callback_url, app_info, 120) do |error, _|
      if error
        raise Exception.new("Failed to respond through callback url")
      end
    end
  end
end
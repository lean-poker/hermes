require 'sidekiq'

class LeanPokerHermes::Workers::Create
  include Sidekiq::Worker

  def perform(callback_url)
    app = LeanPokerHermes::HerokuGateway.instance.create

    app_info = {
        :id => app['id'],
        :name => app['name'],
        :url => "http://#{app['name']}.herokuapp.com/"
    }

    HttpRequestLight.post(callback_url, app_info, 120) do |error, _|
      if error
        raise Exception.new("Failed to respond through callback url")
      end
    end
  end
end
require 'sidekiq'

class LeanPokerHermes::Workers::Create
  include Sidekiq::Worker

  def perform(callback_url, buildpack = nil, environment_variables = nil, target_heroku_api_key = nil)
    app = LeanPokerHermes::HerokuGateway.instance(target_heroku_api_key).create

    begin
      unless buildpack.nil?
        LeanPokerHermes::HerokuGateway.instance(target_heroku_api_key).set_buildpack(app['id'], buildpack)
      end
    rescue Exception => e
      p "Could not set buildpack url!"
      p e.message
    end

    app_info = {
        :id => app['id'],
        :name => app['name'],
        :url => "http://#{app['name']}.herokuapp.com/"
    }

    p "Trying to set Heroku environment variables..."

    env_vars = { 'HOST' => app_info[:url] }.merge(environment_variables||{})
    LeanPokerHermes::HerokuGateway.instance(target_heroku_api_key).set_config_vars(app_info[:name], env_vars)

    p "Sending response to #{callback_url}"
    HttpRequestLight.post(callback_url, app_info, 120) do |error, _|
      if error
        raise Exception.new("Failed to respond through callback url")
      end
    end
  end
end
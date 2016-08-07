require 'sidekiq'
require 'faraday'

class LeanPokerHermes::Workers::Create
  include Sidekiq::Worker

  def perform(callback_url, buildpack = nil, environment_variables = nil, target_heroku_api_key = nil)
    app = LeanPokerHermes::HerokuGateway.instance(target_heroku_api_key).create

    app_info = {
        :id => app['id'],
        :name => app['name'],
        :url => "http://#{app['name']}.herokuapp.com/"
    }

    environment_variables = build_environment_variables(app_info, buildpack, environment_variables)

    setup_environment_variables(callback_url, app_info, environment_variables, target_heroku_api_key)
  end

  private

  def setup_environment_variables(callback_url, app_info, environment_variables, target_heroku_api_key)
    begin
      p "Trying to set Heroku environment variables..."
      LeanPokerHermes::HerokuGateway.instance(target_heroku_api_key).set_config_vars(app_info[:name], environment_variables)
    rescue Exception => e
      p "Could not set environment variables!"
      p e.message
    end

    send_response(callback_url, app_info)
  end

  def build_environment_variables(app_info, buildpack, environment_variables)
    environment_variables = environment_variables||{}
    unless buildpack.nil?
      environment_variables['BUILDPACK_URL'] = buildpack
    end
    environment_variables['HOST'] = app_info[:url]
    environment_variables
  end

  def send_response(callback_url, data)
    p "Sending response to #{callback_url}"
    result = Faraday.post(callback_url, data)
    raise Exception.new("Failed to respond through callback url") unless result.success?
  end
end
require "sidekiq"

class LeanPokerHermes::Workers::SetupEnvironmentVariables
  include Sidekiq::Job

  def perform(callback_url, app_info, environment_variables, target_heroku_api_key)
    p "Trying to set Heroku environment variables..."
    LeanPokerHermes::HerokuGateway.instance(target_heroku_api_key).set_config_vars(app_info["name"], environment_variables)

    LeanPokerHermes::Workers::RespondToCallback.perform_async(callback_url, app_info)
  end

  private

  def send_response(callback_url, data)
    p "Sending response to #{callback_url}"
    result = Faraday.post(callback_url, data)
    raise StandardError.new("Failed to respond through callback url") unless result.success?
  end
end
